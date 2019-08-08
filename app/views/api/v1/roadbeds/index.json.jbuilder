json.roadbeds do
  json.partial! 'api/v1/roadbeds/listing', collection: @roadbeds, as: :roadbed
end