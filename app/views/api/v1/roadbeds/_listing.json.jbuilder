json.id roadbed.guid
json.(roadbed, :name)
json.roadway_id roadbed.roadway.try(:guid)
json.(roadbed, :direction, :number_of_lines)