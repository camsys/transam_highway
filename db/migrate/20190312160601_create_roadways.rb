class CreateRoadways < ActiveRecord::Migration[5.2]
  def change
    create_table :roadways do |t|
      t.string :object_key, null: false, limit: 12
      if ActiveRecord::Base.configurations[Rails.env]['adapter'].include?('mysql2')
        t.string :guid, limit: 36
      else
        t.uuid :guid
      end
      t.references :transam_asset
      t.string :on_under_indicator
      t.references :route_signing_prefix
      t.references :service_level_type
      t.string :route_number
      t.decimal :min_vertical_clearance
      t.boolean :on_base_network
      t.string :lrs_route
      t.string :lrs_subroute
      t.references :functional_class
      t.integer :lanes
      t.integer :average_daily_traffic
      t.integer :average_daily_traffic_year
      t.decimal :total_horizontal_clearance
      t.references :strahnet_designation_type
      t.references :traffic_direction_type
      t.boolean :on_national_higway_system
      t.boolean :on_federal_lands_highway
      t.integer :average_daily_truck_traffic_percent
      t.boolean :on_truck_network
      t.integer :future_average_daily_traffic
      t.integer :future_average_daily_traffic_year

      t.timestamps
    end
  end
end
