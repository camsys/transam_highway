json.id ancillary_condition.guid
json.highway_structure_id ancillary_condition.bridge_like.try(:guid)
json.inspection_id ancillary_condition.inspection.try(:guid)

associations = [:approach_rail_safety_type, :approach_rail_end_safety_type, :ancillary_condition_type]
associations.each do |asso|
  json.(ancillary_condition, "#{asso}_id")
  json.set! asso, ancillary_condition.try(asso).try(:name)
end