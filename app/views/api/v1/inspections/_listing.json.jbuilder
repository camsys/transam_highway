json.id inspection.guid
json.highway_structure_id inspection.highway_structure.try(:guid)
json.event_datetime inspection.event_datetime.try(:strftime, "%m/%d/%Y")
json.(inspection, :object_key, :weather, :temperature, :notes, :inspection_type_id, :organization_type_id, :assigned_organization_id)
json.inspection_type inspection.inspection_type&.name
json.status inspection.status
json.calculated_inspection_due_date inspection.calculated_inspection_due_date
json.inspector_ids inspection.inspectors, :id
