json.culvert_conditions do
  json.partial! 'api/v1/culvert_conditions/listing', collection: @culvert_conditions, as: :culvert_condition
end