# Basic
json.(bridge_like, :object_key, :organization_id)
json.id bridge_like.guid
json.asset_type bridge_like.asset_type.name
json.organization bridge_like.organization.try(:to_s) 
json.(bridge_like, :asset_tag, :external_id, :description, :manufacture_year, :milepoint)

# Location
json.latitude bridge_like.try(:geometry).try(:y)
json.longitude bridge_like.try(:geometry).try(:x)
address = []
address << bridge_like.address1 unless bridge_like.address1.blank?
address << bridge_like.address2 unless bridge_like.address2.blank?
json.address address.join(', ')
json.(bridge_like, :city, :county, :state, :zip)

# Condition
json.calculated_condition bridge_like.calculated_condition

# NBI
json.(bridge_like, :route_number, :features_intersected, :facility_carried, :location_description, :num_spans_main, :num_spans_approach, :length, :border_bridge_state, :border_bridge_pcnt_responsibility, :border_bridge_structure_number, :is_temporary)

# NBI Dates
json.inspection_date bridge_like.inspection_date.try(:strftime, "%m/%d/%Y")

# NBI Associations
associations = [:route_signing_prefix, :main_span_material_type, :main_span_design_construction_type, :approach_spans_material_type, :approach_spans_design_construction_type, :strahnet_designation_type, :deck_structure_type, :wearing_surface_type, :membrane_type, :deck_protection_type, :region, :maintenance_section, :structure_status_type]
associations.each do |asso|
  json.(bridge_like, "#{asso}_id")
end

json.(bridge_like, :bridge_toll_type_id, :vertical_reference_feature_below_id, :lateral_reference_feature_below_id, :min_lateral_clearance_below_right, :service_on_type_id, :service_under_type_id)