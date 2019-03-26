FactoryBot.define do
  factory :roadway do
    association :highway_structure
    on_under_indicator { "MyString" }
    route_signing_prefix { nil }
    service_level_type { nil }
    route_number { "MyString" }
    min_vertical_clearance { "9.99" }
    on_base_network { false }
    lrs_route { "MyString" }
    lrs_subroute { "MyString" }
    functional_class { nil }
    lanes { 1 }
    average_daily_traffic { 1 }
    average_daily_traffic_year { 1 }
    total_horizontal_clearance { "9.99" }
    strahnet_designation_type { nil }
    traffic_direction_type { nil }
    on_national_highway_system { false }
    on_federal_lands_highway { false }
    average_daily_truck_traffic_percent { 1 }
    on_truck_network { false }
    future_average_daily_traffic { 1 }
    future_average_daily_traffic_year { 1 }
  end
end
