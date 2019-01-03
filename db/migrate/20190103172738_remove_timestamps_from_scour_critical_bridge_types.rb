class RemoveTimestampsFromScourCriticalBridgeTypes < ActiveRecord::Migration[5.2]
  def change
    remove_column :scour_critical_bridge_types, :created_at, :string
    remove_column :scour_critical_bridge_types, :updated_at, :string
  end
end
