json.inspections do
  json.partial! 'api/v1/inspections/listing', collection: @inspections, as: :inspection
end

json.elements do
  json.partial! 'api/v1/elements/listing', collection: @elements, as: :element
end

if @highway_structures
  json.structures do
    if @bridges
      json.bridges do
        json.partial! 'api/v1/bridges/listing', collection: @bridges, as: :bridge
      end
    end
  end
end

json.roadways do
  json.partial! 'api/v1/roadways/listing', collection: @roadways, as: :roadway
end

json.bridge_like_conditions do
  json.partial! 'api/v1/bridge_like_conditions/listing', collection: @bridge_like_conditions, as: :bridge_like_condition
end

json.images do 
  json.partial! 'api/v1/images/image', collection: @images, as: :image
end

json.documents do 
  json.partial! 'api/v1/documents/document', collection: @documents, as: :document
end