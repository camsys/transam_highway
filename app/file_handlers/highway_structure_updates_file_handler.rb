#------------------------------------------------------------------------------
#
# HighwayStructureUpdatesFileHandler
#
# Generic class for processing updates for highway structures from a spreadsheet.
#
# This processes a user-created spreadsheet checking for key columns
# and updating accordingly.
#
#------------------------------------------------------------------------------
class HighwayStructureUpdatesFileHandler < AbstractFileHandler

  # Perform the processing
  def process(upload)

    @num_rows_processed = 0
    @num_rows_added = 0
    @num_rows_skipped = 0
    @num_rows_replaced = 0
    @num_rows_failed = 0

    # Get the pertinent info from the upload record
    file_url = upload.file.url                # Usually stored on S3
    organization = upload.organization        # Organization who owns the structures
    system_user = User.find_by(first_name: 'system')

    add_processing_message(1, 'success', "Updating structure status from '#{upload.original_filename}'")
    add_processing_message(1, 'success', "Start time = '#{Time.now}'")

    upload.force_update = true

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

      if brkey_column
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

            Rails.logger.debug "  Processing row #{row}. Bridge Key = '#{asset_tag}'"
            highway_structure = TransamAsset.get_typed_asset(TransamAsset.find_by(asset_tag: asset_tag))

            # Attempt to find the asset
            # complain if we cant find it
            if highway_structure.nil?
              add_processing_message(1, 'warning', "Could not retrieve structure '#{asset_tag}'.")
              @num_rows_failed += 1
              next
            else
              add_processing_message(1, 'success', "Processing row[#{row}]  Bridge Key = '#{asset_tag}'")
            end

            # Map values to columns
            col_vals = {}

            header_cells.except(:brkey).each do |f, i|
              col_vals[f] = cells[i]
            end

            # Make sure this row has data otherwise skip it
            if col_vals.values.all?{|v| v.blank?}
              @num_rows_skipped += 1
              add_processing_message(2, 'info', "No data for row. Skipping.")
              next
            end

            highway_structure.upload = upload

            col_vals.each do |f, v|
              # Check that the field is valid and contains data
              if (highway_structure.respond_to? f) && !v.blank?
                add_processing_message(3, 'success', "Processing #{f.to_s.titleize}")

                #---------------------------------------------------------------------
                # Exceptions
                #---------------------------------------------------------------------
                # Many fields that are not typed or searchable by code have constraints on what may and may not be entered
                if f.to_s == 'city'
                  city_names = District.joins(:district_type).where(district_types: {name: 'Place'}).pluck(:name)
                  if city_names.include? v
                    highway_structure.city = v
                  else
                    add_processing_message(3, 'warning', "'#{v}' is not a valid city. Skipping City assignment.")
                  end
                elsif f.to_s == 'county'
                  county_names = District.joins(:district_type).where(district_types: {name: 'County'}).pluck(:name)
                  if county_names.include? v
                    highway_structure.county = v
                  else
                    add_processing_message(3, 'warning', "'#{v}' is not a valid county. Skipping County assignment.")
                  end
                elsif f.to_s == 'inspection_date'
                  inspection = highway_structure.last_closed_inspection
                  inspection.event_datetime = Chronic.parse(v)
                  unless inspection.save
                    add_processing_message(3, 'warning', "Unable to update inspection date with value '#{v}'. Skipping Inspection Date assignment.")
                  end
                elsif f.to_s == 'structure_key'
                  highway_structure.asset_tag = v
                elsif f.to_s == 'latitude'
                  max_lat = SystemConfig.instance.max_lat
                  min_lat = SystemConfig.instance.min_lat
                  if v.to_f > max_lat || v.to_f < min_lat
                    add_processing_message(3, 'warning', "Latitude must be within #{min_lat} and #{max_lat}. Skipping Latitude assignment.")
                  else
                    highway_structure.latitude = v.to_f
                  end
                elsif f.to_s == 'longitude'
                  max_lon = SystemConfig.instance.max_lon
                  min_lon = SystemConfig.instance.min_lon
                  if v.to_f > max_lon || v.to_f < min_lon
                    add_processing_message(3, 'warning', "Longitude must be within #{min_lon} and #{max_lon}. Skipping Latitude assignment.")
                  else
                    highway_structure.longitude = v.to_f
                  end

                #---------------------------------------------------------------------
                # Associations
                #---------------------------------------------------------------------
                # Default to assigning associations by code. If no existing type corresponds to the code provided, skip it.
                elsif highway_structure.class.reflect_on_association(f)
                  klass = highway_structure.class.reflect_on_association(f).class_name.constantize
                  association_val = klass.find_by(code: v)
                  if association_val
                    highway_structure.send("#{f.to_s}=", association_val)
                  else
                    add_processing_message(3, 'warning', "'#{v}' is not a valid code for #{f.to_s.titleize}. Skipping #{f.to_s.titleize} assignment.")
                  end

                #---------------------------------------------------------------------
                # Raw values
                #---------------------------------------------------------------------
                else
                  highway_structure.send("#{f.to_s}=", v)
                end
              end
            end

            if highway_structure.save

              # If the asset was successfully updated, schedule update the condition and disposition asynchronously
              #Delayed::Job.enqueue AssetUpdateJob.new(@asset.asset.object_key), :priority => 0
              # See if this asset has any dependents that use its spatial reference
              if highway_structure.geometry and highway_structure.occupants.count > 0
                # schedule an update to the spatial references of the dependent assets
                Delayed::Job.enqueue AssetDependentSpatialReferenceUpdateJob.new(highway_structure.object_key), :priority => 0
              end
              add_processing_message(2, 'success', "Structure updated.")
              @num_rows_added += 1
            else
              @num_rows_failed += 1
              Rails.logger.info "Structure did not pass validation."
              add_processing_message(2, 'warning', "Structure update failed: #{highway_structure.errors}")
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