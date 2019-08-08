json.roadbed_lines do
  json.partial! 'api/v1/roadbed_lines/listing', collection: @roadbed_lines, as: :roadbed_line
end