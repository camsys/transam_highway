json.id defect.guid
json.structure_id defect.highway_structure.try(:guid)
json.inspection_id defect.inspection.try(:guid)
json.element_id defect.element.try(:guid)
