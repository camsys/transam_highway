json.element_definitions do
  json.partial! 'api/v1/element_definitions/listing', collection: @element_definitions, as: :element_definition
end