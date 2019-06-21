json.id image.guid
json.feature_id image.imagable.try(:guid)
imagable_type = image.base_imagable_type
imagable_type = image.imagable.try(:asset_type).try(:to_s) if imagable_type == 'TransamAsset'
json.type imagable_type
json.(image, :object_key, :description, :latitude, :longitude, :condition_state, :is_primary)
json.file_name image.original_filename
json.url image.image.try(:url)