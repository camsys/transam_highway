json.id element.guid
json.highway_structure_id element.highway_structure.very_specific.try(:guid)
json.parent_id element.parent.try(:guid)
json.inspection_id element.inspection.try(:guid)
json.(element, :element_definition_id, :object_key, :quantity, :notes)
