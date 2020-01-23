json.id roadway.guid
json.highway_structure_id roadway.highway_structure.try(:guid)
json.(roadway,:facility_carried, :on_under_indicator, :milepoint, :min_vertical_clearance,
              :on_base_network, :strahnet_designation_type_id, 
              :traffic_direction_type_id, :on_truck_network, 
              :lrs_route, :lrs_subroute,
              :service_level_type_id, :route_number, :lanes)
json.route_signing_prefix_id roadway.route_signing_prefix_id
json.route_signing_prefix roadway.route_signing_prefix&.name
