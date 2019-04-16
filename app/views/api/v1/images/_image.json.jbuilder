json.id image.guid
json.feature_id image.imagable.try(:guid)
json.type image.imagable.try(:asset_type).try(:to_s)
json.(image, :object_key, :description)
json.file_name image.original_filename
json.url image.image.try(:url)