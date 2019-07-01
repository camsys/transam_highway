class StreambedProfilePoint < ApplicationRecord

  include TransamObjectKey

  belongs_to :streambed_profile

  default_scope { order(:distance) }

  def self.allowable_params
    [:distance, :value]
  end
end
