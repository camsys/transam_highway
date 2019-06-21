json.id image.guid
json.feature_id image.imagable.try(:guid)
json.type image.imagable_type
json.(image, :object_key, :description, :latitude, :longitude, :condition_state, :is_primary)
json.file_name image.original_filename
json.url image.image.try(:url)