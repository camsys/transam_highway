json.id image.guid
imagable_type = image.imagable_type
json.type imagable_type

if ['Element', 'Defect', 'DefectLocation'].include? imagable_type
  json.structure_id image.base_imagable.highway_structure.transam_asset.try(:guid)
  json.feature_id image.imagable.try(:guid)
  json.inspection_id image.base_imagable.try(:guid)
elsif imagable_type == 'Inspection'
  json.structure_id image.imagable.highway_structure.transam_asset.try(:guid)
  json.feature_id nil
  json.inspection_id image.imagable.try(:guid)
else
  json.structure_id image.base_imagable.try(:guid)
  json.feature_id nil
  json.inspection_id nil
end

json.(image, :object_key, :description, :latitude, :longitude, :condition_state, :is_primary,
      :image_classification_id)
json.file_name image.image.file.filename
json.original_file_name image.original_filename
json.url image.image.try(:url)
if defined? image.image.constrained
  if image.image.constrained.file.exists?
    json.constrained_url image.image.constrained.url
  else
    json.constrained_url image.image&.url
  end
end
json.direction image.compass_point
json.datetime image.created_at
