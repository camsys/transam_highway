json.(highway_structure, :object_key, :asset_tag, :external_id, :state, :county, :city, :location_description, :calculated_condition, :is_temporary, :milepoint, :features_intersected, :remarks)
json.asset_type highway_structure.asset_type.name
unless sshml
  json.(highway_structure, :facility_carried, :approach_roadway_width)
end
json.id highway_structure.guid
json.latitude highway_structure.try(:geometry).try(:y)
json.longitude highway_structure.try(:geometry).try(:x)
json.manufacture_year highway_structure.manufacture_year

associations = [:maintenance_responsibility, :owner, :structure_status_type, :historical_significance_type, :region, :maintenance_section, :main_span_material_type, :main_span_design_construction_type]
if sshml
  associations.reject!{|e| [:main_span_material_type, :main_span_design_construction_type].include?(e)}
  associations.concat([:mast_arm_frame_type, :column_type, :foundation_type, :upper_connection_type])
  json.maintenance_patrol highway_structure.maintenance_patrol
end

associations.each do |asso|
  json.(highway_structure, "#{asso}_id")
end

if highway_structure.inspection_type_settings
  json.inspection_type_settings do
    json.partial! 'api/v1/inspection_type_settings/inspection_type_setting', collection: highway_structure.inspection_type_settings, as: :inspection_type_setting
  end
end

json.(highway_structure, :lanes_on, :lanes_under)