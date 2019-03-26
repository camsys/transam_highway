json.(highway_structure, :object_key, :organization_id, :transam_assetible_type, :asset_subtype_id, :asset_tag, :description, :external_id)
json.id highway_structure.guid
json.latitude highway_structure.try(:geometry).try(:y)
json.longitude highway_structure.try(:geometry).try(:x)
json.asset_subtype highway_structure.asset_subtype.try(:to_s) 
json.in_service_date highway_structure.in_service_date.try(:strftime, "%m/%d/%Y")
