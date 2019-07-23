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

  has_many :roadbeds, dependent: :destroy

  scope :on, -> { where(on_under_indicator: '1') }
  scope :under, -> { where.not(on_under_indicator: '1').order(:on_under_indicator) }

  def reset_lanes_if_needed
    highway_structure.reset_lanes(self) if saved_change_to_attribute?(:lanes)
  end

  def to_s
    if on_under_indicator == '1'
      "On Structure - 1"
    else
      "Under Structure - #{on_under_indicator}"
    end
  end
end
