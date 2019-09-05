class StreambedProfilePoint < ApplicationRecord

  include TransamObjectKey

  belongs_to :streambed_profile

  validates    :distance,  :presence => true, :uniqueness => { :scope => :streambed_profile_id }

  default_scope { order(:distance) }

  def self.allowable_params
    [:streambed_profile, :distance, :value]
  end
end
