if @highway_structures
  json.highway_structures do
    json.partial! 'api/v1/highway_structures/listing', collection: @highway_structures, as: :highway_structure, sshml: false
  end
end