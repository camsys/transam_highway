class AddGuidMaintenanceServiceOrders < ActiveRecord::Migration[5.2]
  def change

    if table_exists? :maintenance_service_orders
      if ActiveRecord::Base.configurations[Rails.env]['adapter'].include?('mysql2')
        add_column :maintenance_service_orders, :guid, :string, limit: 36, index: true, after: :object_key
      else
        add_column :maintenance_service_orders, :guid, :uuid, index: true, after: :object_key
      end
    end
  end
end
