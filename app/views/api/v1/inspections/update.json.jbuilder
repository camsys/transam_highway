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

json.streambed_profile do
  json.partial! 'api/v1/streambed_profiles/listing', streambed_profile: @inspection.streambed_profile
end

json.streambed_profile_points do
  json.partial! 'api/v1/streambed_profile_points/listing', collection: @inspection.streambed_profile&.streambed_profile_points, as: :streambed_profile_point
end

json.roadbeds do
  json.partial! 'api/v1/roadbeds/listing', collection: @inspection.highway_structure.roadways.collect(&:roadbeds).flatten, as: :roadbed
end

json.roadbed_lines do
  json.partial! 'api/v1/roadbed_lines/listing', collection: RoadbedLine.where(inspection: @inspection), as: :roadbed_line
end

if @inspection.highway_structure.respond_to? :maintenance_service_orders
  json.maintenance_items do
    json.partial! 'api/v1/maintenance_items/listing', collection: @inspection.highway_structure.maintenance_service_orders, as: :maintenance_item
  end
end