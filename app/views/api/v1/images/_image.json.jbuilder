json.id image.guid
json.structure_id image.base_imagable.try(:guid)

imagable_type = image.imagable_type
json.type imagable_type
if imagable_type == 'Element' or imagable_type == 'Defect'
  json.feature_id image.imagable.try(:guid)
  json.inspection_id image.imagable.inspection.try(:guid)
elsif imagable_type == 'Inspection'
  json.feature_id nil
  json.inspection_id image.imagable.try(:guid)
else
  json.feature_id nil
  json.inspection_id nil
end

json.(image, :object_key, :description, :latitude, :longitude, :condition_state, :is_primary)
json.file_name image.original_filename
json.url image.image.try(:url)