json.id streambed_profile.guid
json.highway_structure_id streambed_profile.try(:highway_structure).try(:guid)
json.inspection_id streambed_profile.try(:inspection).try(:guid)
json.(streambed_profile, :date, :water_level)