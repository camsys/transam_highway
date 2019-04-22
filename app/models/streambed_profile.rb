class StreambedProfile < ApplicationRecord
  belongs_to :inspection

  has_many :streambed_profile_points
end
