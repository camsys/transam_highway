json.partial! 'api/v1/highway_structures/listing', highway_structure: bridge
json.partial! 'api/v1/bridge_likes/listing', bridge_like: bridge

json.(bridge, :operating_rating, :inventory_rating, :border_bridge_structure_number, :num_spans_main, :num_spans_approach, :max_span_length, :left_curb_sidewalk_width, :right_curb_sidewalk_width, :roadway_width, :deck_width, :min_vertical_clearance_above, :min_vertical_clearance_below, :min_lateral_clearance_below_left, :fracture_critical_inspection_required, :fracture_critical_inspection_frequency, :underwater_inspection_required, :underwater_inspection_frequency, :other_special_inspection_required, :other_special_inspection_frequency, :border_bridge_state, :border_bridge_pcnt_responsibility)

associations = [:design_load_type, :operating_rating_method_type, :inventory_rating_method_type, :bridge_posting_type, :deck_structure_type, :wearing_surface_type, :membrane_type, :deck_protection_type, :approach_spans_material_type, :approach_spans_design_construction_type]
associations.each do |asso|
  json.(bridge, "#{asso}_id")
  json.set! asso, bridge.try(asso).try(:name)
end