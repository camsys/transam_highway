json.id roadbed_line.guid
json.roadbed_id roadbed_line.roadbed.try(:guid)
json.inspection_id roadbed_line.inspection.try(:guid)
json.number(roadbed_line.number == 'R' ? roadbed_line.roadbed&.number_of_lines + 2 : roadbed_line.number.to_i)
json.(roadbed_line, :entry, :exit)