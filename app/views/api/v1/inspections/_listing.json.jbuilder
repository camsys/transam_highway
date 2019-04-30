json.id inspection.guid
json.high_structure_id inspection.highway_structure.try(:guid)
json.event_datetime inspection.event_datetime.try(:strftime, "%m/%d/%Y")
json.(inspection, :weather, :temperature, :notes, :inspection_type_id)
json.inspection_type inspection.inspection_type&.name
inspection_status = inspection.status
inspection_status = 'in_field' if @change_inspection_status && inspection_status == 'assigned'
json.staus inspection_status
json.calculated_inspection_due_date inspection.calculated_inspection_due_date
json.inspectors inspection.inspectors, :to_s
json.inspector_emails inspection.inspectors, :email