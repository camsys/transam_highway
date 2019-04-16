json.(highway_structure, :object_key, :asset_subtype_id, :asset_tag, :external_id, :state, :county, :city, :facility_carried, :location_description, :highway_structurible_type, :calculated_condition, :is_temporary, :milepoint, :approach_roadway_width, :features_intersected, :inspection_frequency, :remarks)
json.id highway_structure.guid
json.latitude highway_structure.try(:geometry).try(:y)
json.longitude highway_structure.try(:geometry).try(:x)
json.asset_subtype highway_structure.asset_subtype.try(:to_s) 
json.manufacture_year highway_structure.manufacture_year

associations = [:maintenance_responsibility, :owner, :structure_status_type, :historical_significance_type, :region, :maintenance_section, :main_span_material_type, :main_span_design_construction_type, :highway_structure_type]
associations.each do |asso|
  json.(highway_structure, "#{asso}_id")
  json.set! asso, highway_structure.try(asso).try(:name)
end