json.bridge_conditions do
  json.partial! 'api/v1/bridge_conditions/listing', collection: @bridge_conditions, as: :bridge_condition
end