json.streambed_profiles do
  json.partial! 'api/v1/streambed_profiles/listing', collection: @profiles, as: :streambed_profile
end