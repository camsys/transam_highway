json.(bridge, :object_key, :organization_id, :transam_assetible_type, :asset_subtype_id, :asset_tag, :description, :external_id)
json.asset_subtype bridge.asset_subtype.try(:to_s) 
json.in_service_date bridge.in_service_date.try(:strftime, "%m/%d/%Y")