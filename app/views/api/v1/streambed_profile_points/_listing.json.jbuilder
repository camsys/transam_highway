json.id streambed_profile_point.guid
json.profile_id streambed_profile_point.try(:streambed_profile).try(:guid)
json.distance streambed_profile_point.distance&.to_f
json.value streambed_profile_point.value&.to_f