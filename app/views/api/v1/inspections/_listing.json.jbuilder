json.id inspection.guid
json.structure_id inspection.highway_structure.try(:guid)
json.date inspection.event_datetime.try(:strftime, "%m/%d/%Y")
json.(inspection, :weather, :temperature, :notes, :inspection_type_id)
json.inspection_type inspection.inspection_type&.name