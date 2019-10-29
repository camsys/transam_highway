json.ancillary_conditions do
  json.partial! 'api/v1/ancillary_conditions/listing', collection: @ancillary_conditions, as: :ancillary_condition
end