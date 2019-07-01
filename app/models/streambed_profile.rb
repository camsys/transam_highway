class StreambedProfile < ApplicationRecord

  include TransamObjectKey

  before_create :set_defaults
  after_create :create_streambed_profile_points

  belongs_to :bridge_like, foreign_key: :transam_asset_id
  belongs_to :inspection
  has_many :streambed_profile_points

  default_scope { order(:date) }

  protected

  def set_defaults
    typed_asset = TransamAsset.get_typed_asset(inspection.highway_structure)
    self.bridge_like ||= (typed_asset.try(:bridge_like) || typed_asset)
    self.date ||= inspection.calculated_inspection_due_date
  end

  def create_streambed_profile_points
    bridge_like.streambed_profiles.last.streambed_profile_points.each do |profile_point|
      self.streambed_profile_points.create(distance: profile_point.distance)
    end
  end
end
