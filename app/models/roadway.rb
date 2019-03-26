class Roadway < ApplicationRecord
  include TransamObjectKey

  # Callbacks
  after_save :reset_lanes_if_needed
  
  belongs_to :highway_structure, foreign_key: :transam_asset_id
  belongs_to :route_signing_prefix
  belongs_to :service_level_type
  belongs_to :functional_class
  belongs_to :strahnet_designation_type
  belongs_to :traffic_direction_type

  scope :on, -> { where(on_under_indicator: '1') }
  scope :under, -> { where.not(on_under_indicator: '1') }

  def reset_lanes_if_needed
    highway_structure.reset_lanes(self) if lanes_changed?
  end
end
