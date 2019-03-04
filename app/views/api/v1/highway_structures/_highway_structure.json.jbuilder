# Basic
json.(highway_structure, :object_key, :organization_id )
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
json.(highway_structure, :route_number, :features_intersected, :location_description, :length, :inspection_frequency, :fracture_critical_inspection_required, :fracture_critical_inspection_frequency, :underwater_inspection_required, :underwater_inspection_frequency, :other_special_inspection_required, :other_special_inspection_frequency, :is_temporary)

# NBI Dates
json.inspection_date highway_structure.inspection_date.try(:strftime, "%m/%d/%Y")
json.fracture_critical_inspection_date highway_structure.fracture_critical_inspection_date.try(:strftime, "%m/%d/%Y")
json.underwater_inspection_date highway_structure.underwater_inspection_date.try(:strftime, "%m/%d/%Y")
json.other_special_inspection_date highway_structure.other_special_inspection_date.try(:strftime, "%m/%d/%Y")

# NBI Associations
associations = [:route_signing_prefix]
associations.each do |asso|
  json.(highway_structure, "#{asso}_id")
  json.set! asso, highway_structure.try(asso).try(:name)
end
