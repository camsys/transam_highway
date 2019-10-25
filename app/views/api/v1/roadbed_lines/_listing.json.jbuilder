json.id roadbed_line.guid
json.roadbed_id roadbed_line.roadbed.try(:guid)
json.inspection_id roadbed_line.inspection.try(:guid)
json.number(roadbed_line.number == 'R' ? roadbed_line.roadbed&.number_of_lines + 2 : roadbed_line.number.to_i)
json.entry roadbed_line.entry == 0.0 ? nil : roadbed_line.entry
json.exit roadbed_line.exit == 0.0 ? nil : roadbed_line.exit
json.minimum_clearance roadbed_line.minimum_clearance == 0.0 ? nil : roadbed_line.minimum_clearance
if roadbed_line.roadbed.try(:use_minimum_clearance?)
  if (roadbed_line.minimum_clearance == nil)
    json.no_restriction true
    json.does_not_exist false
  elsif (roadbed_line.minimum_clearance == 0.0)
    json.no_restriction false
    json.does_not_exist true
  else
    json.no_restriction false
    json.does_not_exist false
  end
else
  if (roadbed_line.entry == nil) && (roadbed_line.exit == nil)
    json.no_restriction true
    json.does_not_exist false
  elsif (roadbed_line.entry == 0.0) || (roadbed_line.exit == 0.0)
    json.no_restriction false
    json.does_not_exist true
  else
    json.no_restriction false
    json.does_not_exist false
  end
end
