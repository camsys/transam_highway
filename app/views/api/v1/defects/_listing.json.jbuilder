json.id defect.guid
json.element_id defect.element.try(:guid)
json.defect_definition_id defect.defect_definition_id
json.inspection_id defect.inspection.try(:guid)
json.highway_structure_id defect.highway_structure.try(:guid)
json.(defect, :condition_state_1_quantity, :condition_state_2_quantity, :condition_state_3_quantity, :condition_state_4_quantity, :total_quantity)
