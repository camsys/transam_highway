class Roadway < ApplicationRecord
  belongs_to :route_signing_prefix
  belongs_to :service_level_type
  belongs_to :functional_class
  belongs_to :strahnet_designation_type
  belongs_to :traffic_direction_type
end
