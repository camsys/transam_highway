class Roadway < ApplicationRecord
  include TransamObjectKey
  has_paper_trail

  # Callbacks
  after_initialize :set_defaults
  after_save :reset_lanes_if_needed

  belongs_to :highway_structure, foreign_key: :transam_asset_id
  belongs_to :route_signing_prefix
  belongs_to :service_level_type
  belongs_to :functional_class
  belongs_to :strahnet_designation_type
  belongs_to :traffic_direction_type

  has_many :roadbeds, dependent: :destroy

  validates :route_signing_prefix, presence: true
  validates :service_level_type, presence: true

  scope :on, -> { where(on_under_indicator: '1') }
  scope :under, -> { where.not(on_under_indicator: '1').order(:on_under_indicator) }

  def self.allowable_params
    [
     :transam_asset_id,
     :on_under_indicator,
     :route_signing_prefix_id,
     :service_level_type_id,
     :route_number,
     :features_intersected,
     :facility_carried,
     :min_vertical_clearance,
     :milepoint,
     :on_base_network,
     :lrs_route,
     :lrs_subroute,
     :functional_class_id,
     :lanes,
     :average_daily_traffic,
     :average_daily_traffic_year,
     :total_horizontal_clearance,
     :strahnet_designation_type_id,
     :traffic_direction_type_id,
     :on_national_highway_system,
     :average_daily_truck_traffic_percent,
     :on_truck_network,
     :future_average_daily_traffic,
     :future_average_daily_traffic_year
    ]
  end

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

  def allowed_indicators
    current_list = highway_structure.roadways.pluck(:on_under_indicator)
    current_list.delete('')

    disallow_two = highway_structure.roadways.count > 2
    count = highway_structure.roadways.count
    case count
    when 0, 1, 2
      list = ['1', '2'] - current_list
    else
      list = ['1'] + (0..(count - 2)).collect{|i| ('A'.ord + i).chr} - current_list
    end

    list << on_under_indicator if on_under_indicator.present?

    list.sort
  end

  protected

  def set_defaults
    if highway_structure
      last_indicator = highway_structure.roadways.pluck(:on_under_indicator).sort.last
      self.on_under_indicator ||=
        case last_indicator
        when nil, ''
          '1'
        when '1'
          '2'
        when '2'
          'B'
        else
          (last_indicator.ord + 1).chr
        end
    end
  end
end
