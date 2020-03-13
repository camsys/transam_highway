json.(bridge_like, :object_key, :asset_tag, :external_id, :length)
unless sshml
  json.(bridge_like, :max_span_length, :left_curb_sidewalk_width, :right_curb_sidewalk_width, :roadway_width, :deck_width, :min_vertical_clearance_above)
end

json.(bridge_like, :min_vertical_clearance_below)

unless sshml
  json.(bridge_like, :min_lateral_clearance_below_left)
end

json.(bridge_like, :min_lateral_clearance_below_right, :num_spans_main)

unless sshml
  json.(bridge_like, :num_spans_approach, :design_load_type_id, :operating_rating, :operating_rating_method_type_id, :inventory_rating, :inventory_rating_method_type_id,
        :bridge_posting_type_id, :approach_spans_material_type_id, :approach_spans_design_construction_type_id)
end
json.id bridge_like.guid
json.in_service_date bridge_like.in_service_date.try(:strftime, "%m/%d/%Y")
json.latitude bridge_like.try(:geometry).try(:y)
json.longitude bridge_like.try(:geometry).try(:x)
json.(bridge_like, :bridge_toll_type_id, :vertical_reference_feature_below_id, :lateral_reference_feature_below_id, :service_on_type_id, :service_under_type_id)