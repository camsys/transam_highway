if streambed_profile
  json.id streambed_profile.guid
  json.highway_structure_id streambed_profile.try(:bridge_like).try(:guid)
  json.inspection_id streambed_profile.try(:inspection).try(:guid)
  json.date streambed_profile.date.try(:strftime, "%m/%d/%Y")
  json.water_level streambed_profile.water_level&.to_f
  json.reference_line streambed_profile.reference_line
  json.water_level_reference streambed_profile.water_level_reference
end