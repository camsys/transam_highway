json.partial! 'api/v1/associations/listing'

if @highway_structures
  json.highway_structures do
    json.partial! 'api/v1/highway_structures/listing', collection: @highway_structures, as: :highway_structure
  end
end

json.defect_definitions do
  json.partial! 'api/v1/defect_definitions/listing', collection: @defect_definitions, as: :defect_definition
end

json.element_definitions do
  json.partial! 'api/v1/element_definitions/listing', collection: @element_definitions, as: :element_definition
end


json.element_defect_definitions do
  json.array! @element_defect_definitions
end

json.element_defect_definitions @element_defect_definitions
