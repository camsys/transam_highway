json.(highway_structure, :object_key, :asset_tag, :county, :city, :facility_carried, :calculated_condition, :milepoint, :inspection_frequency)
json.id highway_structure.guid
json.asset_type highway_structure.asset_type.name
json.latitude highway_structure.try(:geometry).try(:y)
json.longitude highway_structure.try(:geometry).try(:x)
json.manufacture_year highway_structure.manufacture_year

associations = [:owner, :region]
associations.each do |asso|
  json.set! asso, highway_structure.try(asso).try(:name)
end

json.(highway_structure, :lanes_on, :lanes_under)