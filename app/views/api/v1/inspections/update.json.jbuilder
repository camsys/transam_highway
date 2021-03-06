json.structure do
  structure = TransamAsset.get_typed_asset(@inspection.highway_structure)
  is_sshml = structure.is_a? AncillaryStructure
  json.partial! 'api/v1/highway_structures/listing', highway_structure: structure, sshml: is_sshml
  json.partial! 'api/v1/bridge_likes/listing', bridge_like: structure, sshml: is_sshml
end

json.inspection do
  json.partial! 'api/v1/inspections/listing',  inspection: @inspection
end

json.elements do
  json.partial! 'api/v1/elements/listing', collection: @inspection.elements, as: :element
end

json.defects do
  json.partial! 'api/v1/defects/listing', collection: @inspection.elements.collect(&:defects).sum([]), as: :defect
end

json.defect_locations do
  json.partial! 'api/v1/defect_locations/listing', collection: DefectLocation.where(defect: @inspection.elements.collect(&:defects).sum([])), as: :defect_location
end

case @inspection.highway_structure.asset_subtype.asset_type.name
when "Bridge" || "MiscStructure"
  json.bridge_conditions do
    json.partial! 'api/v1/bridge_conditions/listing', bridge_condition: @inspection.becomes(BridgeCondition).reload
  end
when "Culvert"
  json.culvert_conditions do
    json.partial! 'api/v1/culvert_conditions/listing', culvert_condition: @inspection.becomes(CulvertCondition).reload
  end
when "HighwaySign" || "HighwaySignal" || "HighMastLight"
  json.ancillary_conditions do
    json.partial! 'api/v1/ancillary_conditions/listing', ancillary_condition: @inspection.becomes(AncillaryCondition).reload
  end
end

json.images do
  json.partial! 'api/v1/images/image', collection: @inspection.images, as: :image
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

if @inspection.highway_structure.respond_to? :maintenance_history
  json.maintenance_items do
    json.partial! 'api/v1/maintenance_items/listing', collection: @inspection.highway_structure.maintenance_service_orders, as: :maintenance_item
  end
end
