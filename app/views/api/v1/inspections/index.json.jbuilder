json.users User.all, :id, :name, :email, :organization_id

json.inspections do
  json.partial! 'api/v1/inspections/listing', collection: @inspections, as: :inspection
end

json.elements do
  json.partial! 'api/v1/elements/listing', collection: @elements, as: :element
end

json.defects do
  json.partial! 'api/v1/defects/listing', collection: @defects, as: :defect
end

json.defect_locations do
  json.partial! 'api/v1/defect_locations/listing', collection: @defect_locations, as: :defect_location
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
    if @highway_signs
      json.highway_signs do
        json.partial! 'api/v1/ancillary_structures/listing', collection: @highway_signs, as: :ancillary_structure
      end
    end
    if @highway_signals
      json.highway_signals do
        json.partial! 'api/v1/ancillary_structures/listing', collection: @highway_signals, as: :ancillary_structure
      end
    end
    if @high_mast_lights
      json.high_mast_lights do
        json.partial! 'api/v1/ancillary_structures/listing', collection: @high_mast_lights, as: :ancillary_structure
      end
    end
    if @miscellaneous_structures
      json.miscellaneous do
        json.partial! 'api/v1/bridges/listing', collection: @miscellaneous_structures, as: :bridge
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

json.ancillary_conditions do
  json.partial! 'api/v1/ancillary_conditions/listing', collection: @ancillary_conditions, as: :ancillary_condition
end

json.images do 
  json.partial! 'api/v1/images/image', collection: @images, as: :image
end

json.documents do 
  json.partial! 'api/v1/documents/document', collection: @documents, as: :document
end

json.streambed_profiles do
  json.partial! 'api/v1/streambed_profiles/listing', collection: @profiles, as: :streambed_profile
end

json.streambed_profile_points do
  json.partial! 'api/v1/streambed_profile_points/listing', collection: @profile_points, as: :streambed_profile_point
end

json.roadbeds do
  json.partial! 'api/v1/roadbeds/listing', collection: @roadbeds, as: :roadbed
end

json.roadbed_lines do
  json.partial! 'api/v1/roadbed_lines/listing', collection: @roadbed_lines, as: :roadbed_line
end

if @highway_structures&.first.respond_to? :maintenance_history
  json.maintenance_items do
    json.partial! 'api/v1/maintenance_items/listing', collection: @maintenance_items, as: :maintenance_item
  end
end