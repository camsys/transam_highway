json.(element_definition, :id, :number, :long_name, :short_name, :description, :assembly_type_id, :element_material_id, :element_classification_id, :quantity_unit)
json.assembly_type element_definition.try(:assembly_type).try(:to_s)
json.element_material element_definition.try(:element_material).try(:to_s)
json.element_classification element_definition.try(:element_classification).try(:to_s)
