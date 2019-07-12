if @user&.organization
  json.organization @user.organization, :id, :name, :short_name

  json.users @user.organization.users, :id, :name, :email, :organization_id
end

json.inspections do
  json.partial! 'api/v1/inspections/listing', collection: @inspections, as: :inspection
end

json.elements do
  json.partial! 'api/v1/elements/listing', collection: @elements, as: :element
end

json.defects do
  json.partial! 'api/v1/defects/listing', collection: @defects, as: :defect
end

if @highway_structures
  json.structures do
    if @bridges
      json.bridges do
        json.partial! 'api/v1/bridges/listing', collection: @bridges, as: :bridge
      end
    end
    if @culverts
      json.culverts do
        json.partial! 'api/v1/culverts/listing', collection: @culverts, as: :culvert
      end
    end
  end
end

json.roadways do
  json.partial! 'api/v1/roadways/listing', collection: @roadways, as: :roadway
end

json.bridge_conditions do
  json.partial! 'api/v1/bridge_conditions/listing', collection: @bridge_conditions, as: :bridge_condition
end

json.culvert_conditions do
  json.partial! 'api/v1/culvert_conditions/listing', collection: @culvert_conditions, as: :culvert_condition
end

json.images do 
  json.partial! 'api/v1/images/image', collection: @images, as: :image
end

json.documents do 
  json.partial! 'api/v1/documents/document', collection: @documents, as: :document
end