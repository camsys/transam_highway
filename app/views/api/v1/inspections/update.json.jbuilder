json.inspection do
  json.partial! 'api/v1/inspections/listing',  inspection: @inspection
end

json.elements do
  json.partial! 'api/v1/elements/listing', collection: @inspection.elements, as: :element
end

json.defects do
  json.partial! 'api/v1/defects/listing', collection: @inspection.elements.collect(&:defects).sum, as: :defect
end

case @inspection.highway_structure.asset_subtype.asset_type.name
when "Bridge"
  json.bridge_conditions do
    json.partial! 'api/v1/bridge_conditions/listing', bridge_condition: @inspection.becomes(BridgeCondition).reload
  end
when "Culvert"
  json.culvert_conditions do
    json.partial! 'api/v1/culvert_conditions/listing', culvert_condition: @inspection.becomes(CulvertCondition).reload
  end
end

json.images do 
  json.partial! 'api/v1/images/image', collection: @images, as: :image
end

json.documents do 
  json.partial! 'api/v1/documents/document', collection: @documents, as: :document
end
