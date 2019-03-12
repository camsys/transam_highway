json.elements do
  json.partial! 'api/v1/elements/listing', collection: @elements, as: :element
end