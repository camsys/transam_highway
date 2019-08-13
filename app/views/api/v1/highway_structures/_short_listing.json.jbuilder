json.(highway_structure, :object_key, :asset_subtype_id, :asset_tag, :county, :city, :facility_carried, :highway_structurible_type, :calculated_condition, :milepoint, :inspection_frequency)
json.id highway_structure.guid
json.latitude highway_structure.try(:geometry).try(:y)
json.longitude highway_structure.try(:geometry).try(:x)
json.asset_subtype highway_structure.asset_subtype.try(:to_s) 
json.manufacture_year highway_structure.manufacture_year

associations = [:owner, :region, :highway_structure_type]
associations.each do |asso|
  json.set! asso, highway_structure.try(asso).try(:name)
end