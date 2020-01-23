json.id bridge_like_condition.guid
json.highway_structure_id bridge_like_condition.bridge_like.try(:guid)
json.inspection_id bridge_like_condition.inspection.try(:guid)

associations = [:operational_status_type, :deck_condition_rating_type, :superstructure_condition_rating_type, :substructure_condition_rating_type, :channel_condition_type, :structural_appraisal_rating_type, :waterway_appraisal_rating_type, :approach_alignment_appraisal_rating_type, :scour_critical_bridge_type, :railings_safety_type, :transitions_safety_type, :approach_rail_safety_type, :approach_rail_end_safety_type, :culvert_condition_type]
associations.each do |asso|
  json.(bridge_like_condition, "#{asso}_id")
end