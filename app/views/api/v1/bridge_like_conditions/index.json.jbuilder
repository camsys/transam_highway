json.bridge_like_conditions do
  json.partial! 'api/v1/bridge_like_conditions/listing', collection: @bridge_like_conditions, as: :bridge_like_condition
end