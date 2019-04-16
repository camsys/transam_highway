# Basic
json.(bridge_like, :object_key, :organization_id)
json.id bridge_like.guid
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
json.(bridge_like, :route_number, :features_intersected, :facility_carried, :location_description, :num_spans_main, :num_spans_approach, :length, :inspection_frequency, :fracture_critical_inspection_required, :fracture_critical_inspection_frequency, :underwater_inspection_required, :underwater_inspection_frequency, :other_special_inspection_required, :other_special_inspection_frequency, :border_bridge_state, :border_bridge_pcnt_responsibility, :border_bridge_structure_number, :is_temporary)

# NBI Dates
json.inspection_date bridge_like.inspection_date.try(:strftime, "%m/%d/%Y")
json.fracture_critical_inspection_date bridge_like.fracture_critical_inspection_date.try(:strftime, "%m/%d/%Y")
json.underwater_inspection_date bridge_like.underwater_inspection_date.try(:strftime, "%m/%d/%Y")
json.other_special_inspection_date bridge_like.other_special_inspection_date.try(:strftime, "%m/%d/%Y")

# NBI Associations
associations = [:route_signing_prefix, :main_span_material_type, :main_span_design_construction_type, :approach_spans_material_type, :approach_spans_design_construction_type, :strahnet_designation_type, :deck_structure_type, :wearing_surface_type, :membrane_type, :deck_protection_type, :region, :maintenance_section, :structure_status_type]
associations.each do |asso|
  json.(bridge_like, "#{asso}_id")
  json.set! asso, bridge_like.try(asso).try(:name)
end
