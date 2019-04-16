json.(bridge_like, :object_key, :asset_subtype_id, :asset_tag, :external_id, :length)
json.id bridge_like.guid
json.asset_subtype bridge_like.asset_subtype.try(:to_s) 
json.in_service_date bridge_like.in_service_date.try(:strftime, "%m/%d/%Y")
json.latitude bridge_like.try(:geometry).try(:y)
json.longitude bridge_like.try(:geometry).try(:x)
