if @bridges
  json.partial! 'api/v1/bridges/bridge_listing', collection: @bridges, as: :bridge
end