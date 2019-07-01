class StreambedProfilePoint < ApplicationRecord

  include TransamObjectKey

  belongs_to :streambed_profile

  def self.allowable_params
    [:distance, :value]
  end
end
