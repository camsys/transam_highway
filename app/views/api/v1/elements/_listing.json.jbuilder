json.id, :guid
json.structure_id, element.highway_structure.try(:guid)
json.inspection_id, element.inspection.try(:guid)
json.parent_id, element.parent.try(:guid)
