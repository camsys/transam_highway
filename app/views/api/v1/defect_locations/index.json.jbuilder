json.defect_locations do
  json.partial! 'api/v1/defect_locations/listing', collection: @defect_locations, as: :defect_location
end