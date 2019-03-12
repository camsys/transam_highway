json.inspections do
  json.partial! 'api/v1/inspections/listing', collection: @inspections, as: :inspection
end