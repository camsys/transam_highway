json.maintenance_items do
  json.partial! 'api/v1/maintenance_items/listing', collection: @maintenance_items, as: :maintenance_item
end