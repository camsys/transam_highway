json.id image.guid
json.feature_id image.imagable.try(:guid)
json.(image, :object_key, :description)
json.url image.image.try(:url)