if @culverts
  json.culverts do
    json.partial! 'api/v1/culverts/listing', collection: @culverts, as: :culvert
  end
end