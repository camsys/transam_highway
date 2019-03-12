json.id document.guid
json.feature_id document.documentable.try(:guid)
json.(document, :object_key, :description)
json.url document.document.try(:url)