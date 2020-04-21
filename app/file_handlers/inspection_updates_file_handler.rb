#------------------------------------------------------------------------------
#
# InspectionUpdatesFileHandler
#
# Generic class for processing updates for inspections from a spreadsheet.
#
# This processes a user-created spreadsheet checking for key columns
# and updating accordingly.
#
#------------------------------------------------------------------------------
class InspectionUpdatesFileHandler < AbstractFileHandler

  # Perform the processing
  def process(upload)

    @num_rows_processed = 0
    @num_rows_added = 0
    @num_rows_skipped = 0
    @num_rows_replaced = 0
    @num_rows_failed = 0

    # Get the pertinent info from the upload record
    file_url = upload.file.url                # Usually stored on S3
    organization = upload.organization        # Organization who owns the assets
    system_user = User.find_by(first_name: 'system')                # System user is always the first user

    add_processing_message(1, 'success', "Updating inspection status from '#{upload.original_filename}'")
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
      inspection_type_column = header_cells[:inspection_type]
      inspection_due_date_column = header_cells[:inspection_due_date]

      if brkey_column && inspection_type_column && inspection_due_date_column
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

            # Get the inspection by brkey (asset tag), inspection type, and due date
            asset_tag = cells[brkey_column].to_s
            inspection_type = cells[inspection_type_column].to_s
            inspection_due_date = cells[inspection_due_date_column].to_s

            Rails.logger.debug "  Processing row #{row}. Bridge Key = '#{asset_tag}', Inspection Type = '#{inspection_type}', Due Date = '#{inspection_due_date}'"
            inspection = Inspection.get_typed_inspection(Inspection.joins(highway_structure: :transam_asset).joins(:inspection_type)
                         .find_by(transam_assets: {asset_tag: asset_tag},
                                  inspection_types: {name: inspection_type},
                                  calculated_inspection_due_date: Chronic.parse(inspection_due_date)))

            # Attempt to find the asset
            # complain if we cant find it
            if inspection.nil?
              add_processing_message(1, 'warning', "Could not retrieve #{inspection_type} inspection for '#{asset_tag}' with due date #{inspection_due_date}.")
              @num_rows_failed += 1
              next
            else
              add_processing_message(1, 'success', "Processing row[#{row}]  Bridge Key = '#{asset_tag}', Inspection Type = '#{inspection_type}', Due Date = '#{inspection_due_date}'")
            end

            # Map values to columns
            col_vals = {}

            header_cells.except(:brkey, :inspection_type, :inspection_due_date).each do |f, i|
              col_vals[f] = cells[i]
            end

            # Make sure this row has data otherwise skip it
            if col_vals.values.all?{|v| v.blank?}
              @num_rows_skipped += 1
              add_processing_message(2, 'info', "No data for row. Skipping.")
              next
            end

            col_vals.each do |f, v|
              # Check that the field is valid and contains data
              if (inspection.respond_to? f) && !v.blank?
                add_processing_message(3, 'success', "Processing #{f.to_s.titleize}")

                #---------------------------------------------------------------------
                # Associations
                #---------------------------------------------------------------------
                # Default to assigning associations by code. If no existing type corresponds to the code provided, skip it.
                if inspection.class.reflect_on_association(f)
                  klass = inspection.class.reflect_on_association(f).class_name.constantize
                  association_val = klass.find_by(code: v)
                  if association_val
                    inspection.send("#{f.to_s}=", association_val)
                  else
                    add_processing_message(3, 'warning', "'#{v}' is not a valid code for #{f.to_s.titleize}. Skipping #{f.to_s.titleize} assignment.")
                  end

                #---------------------------------------------------------------------
                # Raw values
                #---------------------------------------------------------------------
                else
                  inspection.send("#{f.to_s}=", v)
                end
              end
            end

            if inspection.save

              # do any automatic workflow transitions that are allowed
              (Inspection.automatic_transam_workflow_transitions & inspection.allowable_events).each do |transition|
                if inspection.machine.fire_state_event(transition)
                  WorkflowEvent.create(creator: current_user, accountable: inspection, event_type: transition)
                end
              end
              add_processing_message(2, 'success', "Inspection updated.")
              @num_rows_added += 1
            else
              @num_rows_failed += 1
              Rails.logger.info "Inspection did not pass validation."
              add_processing_message(2, 'warning', "Inspection update failed: #{inspection.errors}")
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
