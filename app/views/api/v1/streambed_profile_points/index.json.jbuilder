json.streambed_profile_points do
  json.partial! 'api/v1/streambed_profile_points/listing', collection: @profile_points, as: :streambed_profile_point
end