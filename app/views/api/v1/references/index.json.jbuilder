json.partial! 'api/v1/associations/listing'

json.organizations Organization.active.all, :id, :name, :short_name

if @highway_structures
  json.structures do
    if @bridges
      json.bridges do
        json.partial! 'api/v1/highway_structures/short_listing', collection: @bridges, as: :highway_structure
      end
    end
    if @culverts
      json.culverts do
        json.partial! 'api/v1/highway_structures/short_listing', collection: @culverts, as: :highway_structure
      end
    end
    if @highway_signs
      json.highway_signs do
        json.partial! 'api/v1/highway_structures/short_listing', collection: @highway_signs, as: :highway_structure
      end
    end
    if @highway_signals
      json.highway_signals do
        json.partial! 'api/v1/highway_structures/short_listing', collection: @highway_signals, as: :highway_structure
      end
    end
    if @high_mast_lights
      json.high_mast_lights do
        json.partial! 'api/v1/highway_structures/short_listing', collection: @high_mast_lights, as: :highway_structure
      end
    end
    if @misc
      json.miscellaneous do
        json.partial! 'api/v1/highway_structures/short_listing', collection: @misc, as: :highway_structure
      end
    end
  end
end

json.defect_definitions do
  json.partial! 'api/v1/defect_definitions/listing', collection: @defect_definitions, as: :defect_definition
end

json.element_definitions do
  json.partial! 'api/v1/element_definitions/listing', collection: @element_definitions, as: :element_definition
end

json.element_defect_definitions @element_defect_definitions
