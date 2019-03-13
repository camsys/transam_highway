json.roadways do
  json.partial! 'api/v1/roadways/listing', collection: @roadways, as: :roadway
end