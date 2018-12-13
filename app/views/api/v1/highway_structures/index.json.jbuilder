if @highway_structures
  json.highway_structures do
    json.partial! 'api/v1/highway_structures/highway_structure_listing', collection: @highway_structures, as: :highway_structure
  end
end