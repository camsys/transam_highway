json.id image.guid
imagable_type = image.imagable_type
json.type imagable_type

if imagable_type == 'Element' or imagable_type == 'Defect'
  json.structure_id image.base_imagable.highway_structure.transam_asset.try(:guid)
  json.feature_id image.imagable.try(:guid)
  json.inspection_id image.base_imagable.try(:guid)
elsif imagable_type == 'Inspection'
  json.structure_id image.base_imagable.try(:guid)
  json.feature_id nil
  json.inspection_id image.imagable.try(:guid)
else
  json.structure_id image.base_imagable.try(:guid)
  json.feature_id nil
  json.inspection_id nil
end

json.(image, :object_key, :description, :latitude, :longitude, :condition_state, :is_primary)
json.file_name image.image.file.filename
json.original_file_name image.original_filename
json.url image.image.try(:url)
json.category image.image_classification.name
json.direction image.compass_point