json.defect_definitions do
  json.partial! 'api/v1/defect_definitions/listing', collection: @defect_definitions, as: :defect_definition
end