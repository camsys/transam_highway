json.partial! 'api/v1/highway_structures/listing', highway_structure: bridge, sshml: false
json.partial! 'api/v1/bridge_likes/listing', bridge_like: bridge, sshml: false

json.(bridge, :border_bridge_structure_number, :border_bridge_state, :border_bridge_pcnt_responsibility)

associations = [:deck_structure_type, :wearing_surface_type, :membrane_type, :deck_protection_type]
associations.each do |asso|
  json.(bridge, "#{asso}_id")
end