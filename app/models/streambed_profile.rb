class StreambedProfile < ApplicationRecord

  include TransamObjectKey

  before_create :set_defaults
  after_create :create_streambed_profile_points

  belongs_to :bridge_like, foreign_key: :transam_asset_id
  belongs_to :inspection
  has_many :streambed_profile_points

  default_scope { order(:date) }

  def self.allowable_params
    [
        :transam_asset_id,
        :date,
        :water_level
    ]
  end

  # look at all related streambed profiles associated with the asset to get all possible columns
  # this profile instance might not have all those columns but these are all the columns it could have
  # on create, it pulls these columns. it doesn't update later if new columns are added later or changed
  def all_possible_distances
    bridge_like ? bridge_like.streambed_profiles.map{|x| x.streambed_profile_points.pluck(:distance)}.flatten.uniq.sort : []
  end

  protected

  def set_defaults
    if inspection
      typed_asset = TransamAsset.get_typed_asset(inspection.highway_structure)
      self.bridge_like ||= (typed_asset.try(:bridge_like) || typed_asset)
      self.date ||= inspection.calculated_inspection_due_date
    end
  end

  def create_streambed_profile_points
    all_possible_distances.each do |dist|
      self.streambed_profile_points.create(distance: dist)
    end
  end
end
