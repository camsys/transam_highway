json.(bridge_like, :object_key, :asset_tag, :external_id, :length)
json.id bridge_like.guid
json.in_service_date bridge_like.in_service_date.try(:strftime, "%m/%d/%Y")
json.latitude bridge_like.try(:geometry).try(:y)
json.longitude bridge_like.try(:geometry).try(:x)
json.(bridge_like, :bridge_toll_type_id, :vertical_reference_feature_below_id, :lateral_reference_feature_below_id, :min_lateral_clearance_below_right, :service_on_type_id, :service_under_type_id)