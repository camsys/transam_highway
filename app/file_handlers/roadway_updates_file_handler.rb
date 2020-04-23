#------------------------------------------------------------------------------
#
# RoadwaysUpdatesFileHandler
#
# Generic class for processing updates for roadways from a spreadsheet.
#
# This processes a user-created spreadsheet checking for key columns
# and updating accordingly.
#
#------------------------------------------------------------------------------
class RoadwayUpdatesFileHandler < AbstractFileHandler

  # Perform the processing
  def process(upload)

    @num_rows_processed = 0
    @num_rows_added = 0
    @num_rows_skipped = 0
    @num_rows_replaced = 0
    @num_rows_failed = 0

    # Get the pertinent info from the upload record
    file_url = upload.file.url                # Usually stored on S3
    organization = upload.organization        # Organization who owns the roadways
    system_user = User.find_by(first_name: 'system')

    add_processing_message(1, 'success', "Updating roadway status from '#{upload.original_filename}'")
    add_processing_message(1, 'success', "Start time = '#{Time.now}'")

    # Open the spreadsheet and start to process the updates
    begin

      reader = SpreadsheetReader.new(file_url)
      reader.open(reader.find_sheets.first)

      Rails.logger.info "  File Opened."
      Rails.logger.info "  Num Rows = #{reader.num_rows}, Num Cols = #{reader.num_cols}"

      # Process header row
      header_row = 1
      header_cells = reader.read(header_row).each_with_index.map{|c, i| [c.to_s.parameterize.underscore.to_sym, i]}.to_h
      brkey_column = header_cells[:brkey]
      on_under_indicator_column = header_cells[:on_under_indicator]

      if brkey_column && on_under_indicator_column
        # Process each data row
        count_blank_rows = 0
        first_row = 2
        first_row.upto(reader.last_row) do |row|
          # Read the next row from the spreadsheet
          cells = reader.read(row)
          if reader.empty_row?
            count_blank_rows += 1
            if count_blank_rows > 10
              break
            end
          else
            notes = []
            count_blank_rows = 0
            @num_rows_processed += 1

            # Get the structure by brkey (asset tag)
            asset_tag = cells[brkey_column].to_s
            on_under_indicator = cells[on_under_indicator_column].to_s

            Rails.logger.debug "  Processing row #{row}. Bridge Key = '#{asset_tag}', On Under Indicator = '#{on_under_indicator}'"
            roadway = Roadway.joins(highway_structure: :transam_asset).find_by(transam_assets: {asset_tag: asset_tag}, on_under_indicator: on_under_indicator)

            # Attempt to find the roadway
            # complain if we cant find it
            if roadway.nil?
              add_processing_message(1, 'warning', "Could not retrieve roadway for '#{asset_tag}' with on under indicator #{on_under_indicator}.")
              @num_rows_failed += 1
              next
            else
              add_processing_message(1, 'success', "Processing row[#{row}]  Bridge Key = '#{asset_tag}', On Under Indicator = #{on_under_indicator}")
            end

            # Map values to columns
            col_vals = {}

            header_cells.except(:brkey, :on_under_indicator).each do |f, i|
              col_vals[f] = cells[i]
            end

            # Make sure this row has data otherwise skip it
            if col_vals.values.all?{|v| v.blank?}
              @num_rows_skipped += 1
              add_processing_message(2, 'info', "No data for row. Skipping.")
              next
            end

            roadway.upload = upload

            col_vals.each do |f, v|
              # Check that the field is valid and contains data
              if (roadway.respond_to? f) && !v.blank?
                add_processing_message(3, 'success', "Processing #{f.to_s.titleize}")

                #---------------------------------------------------------------------
                # Exceptions
                #---------------------------------------------------------------------
                # Many fields that are not typed or searchable by code have constraints on what may and may not be entered
                if f.to_s == 'average_daily_traffic' || f.to_s == 'future_average_daily_traffic' || f.to_s == 'milepoint'
                  if v.to_i >= 0
                    roadway.send("#{f.to_s}=", v)
                  else
                    add_processing_message(3, 'warning', "#{f.to_s.titleize} cannot be a negative number. Skipping #{f.to_s.titleize} assignment.")
                  end
                elsif f.to_s == 'average_daily_traffic_year'
                  adt_min_year = [roadway.average_daily_traffic_year, (Date.today.year - 20)].compact.max
                  adt_max_year = Date.today.year
                  if (adt_min_year..adt_max_year).to_a.include? v
                    roadway.average_daily_traffic_year = v
                  else
                    add_processing_message(3, 'warning', "Average Daily Traffic Year must be between #{adt_min_year} and #{adt_max_year}. Skipping Average Daily Traffic Year assignment.")
                  end
                elsif f.to_s == 'average_daily_truck_traffic_percent'
                  if v.to_i >= 0 && v.to_i <= 100
                    roadway.average_daily_truck_traffic_percent = v
                  else
                    add_processing_message(3, 'warning', "Average Daily Truck Traffic must be between 0 and 100. Skipping Average Daily Truck Traffic Percent assignment.")
                  end
                elsif f.to_s == 'future_average_daily_traffic_year'
                  future_adt_min_year = [[Date.today.year, roadway.future_average_daily_traffic_year].compact.min, Date.today.year - 20].max
                  future_adt_max_year = Date.today.year + 20
                  if (future_adt_min_year..future_adt_max_year).to_a.include? v
                    roadway.future_average_daily_traffic_year = v
                  else
                    add_processing_message(3, 'warning', "Future Average Daily Traffic Year must be between #{future_adt_min_year} and #{future_adt_max_year}. Skipping Future Average Daily Traffic Year assignment.")
                  end
                elsif f.to_s == 'route_number'
                  if v.length <= 5
                    roadway.route_number = v
                  else
                    add_processing_message(3, 'warning', "Route Number must be 5 characters or less. Skipping Route Number assignment.")
                  end

                  #---------------------------------------------------------------------
                  # Associations
                  #---------------------------------------------------------------------
                  # Default to assigning associations by code. If no existing type corresponds to the code provided, skip it.
                elsif roadway.class.reflect_on_association(f)
                  klass = roadway.class.reflect_on_association(f).class_name.constantize
                  association_val = klass.find_by(code: v)
                  if association_val
                    roadway.send("#{f.to_s}=", association_val)
                  else
                    add_processing_message(3, 'warning', "'#{v}' is not a valid code for #{f.to_s.titleize}. Skipping #{f.to_s.titleize} assignment.")
                  end

                  #---------------------------------------------------------------------
                  # Raw values
                  #---------------------------------------------------------------------
                else
                  roadway.send("#{f.to_s}=", v)
                end
              end
            end

            if roadway.save
              asset = roadway.highway_structure
              asset.reload
              count = asset.roadways.count
              has_one = asset.roadways.exists?(on_under_indicator: '1')
              if (has_one && count == 2) || (count == 1)
                # If there's an A, change it to 2
                r = asset.roadways.find_by(on_under_indicator: 'A')
                r&.update_attributes(on_under_indicator: '2')
              else
                # If there's a 2, change it to A
                r = asset.roadways.find_by(on_under_indicator: '2')
                r&.update_attributes(on_under_indicator: 'A')
              end

              add_processing_message(2, 'success', "Roadway updated.")
              @num_rows_added += 1
            else
              @num_rows_failed += 1
              Rails.logger.info "Roadway did not pass validation."
              add_processing_message(2, 'warning', "Roadway update failed: #{roadway.errors}")
            end
          end
        end
      end

      @new_status = FileStatusType.find_by_name("Complete")
    rescue => e
      Rails.logger.warn "Exception caught: #{e.backtrace.join("\n")}"
      @new_status = FileStatusType.find_by_name("Errored")
      raise e
    ensure
      reader.close unless reader.nil?
    end

    add_processing_message(1, 'success', "Processing Completed at  = '#{Time.now}'")

  end

  # Init
  def initialize(upload)
    super
    @upload = upload
  end

end