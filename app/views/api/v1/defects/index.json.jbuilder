json.defects do
  json.partial! 'api/v1/defects/listing', collection: @defects, as: :defect
end