# Basic
json.(highway_structure, :object_key, :organization_id)
json.id highway_structure.guid
json.asset_type highway_structure.asset_type.name
json.organization highway_structure.organization.try(:to_s) 
json.(highway_structure, :asset_tag, :external_id, :description, :manufacture_year)

# Location
json.latitude highway_structure.try(:geometry).try(:y)
json.longitude highway_structure.try(:geometry).try(:x)
address = []
address << highway_structure.address1 unless highway_structure.address1.blank?
address << highway_structure.address2 unless highway_structure.address2.blank?
json.address address.join(', ')
json.(highway_structure, :city, :county, :state, :zip)

# NBI
json.(highway_structure, :route_number, :features_intersected, :location_description, :length)

# NBI Dates
json.inspection_date highway_structure.inspection_date.try(:strftime, "%m/%d/%Y")

# NBI Associations
associations = [:route_signing_prefix]
associations.each do |asso|
  json.(highway_structure, "#{asso}_id")
end

json.(highway_structure, :lanes_on, :lanes_under)