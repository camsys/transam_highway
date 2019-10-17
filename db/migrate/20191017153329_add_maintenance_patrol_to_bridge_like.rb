class AddMaintenancePatrolToBridgeLike < ActiveRecord::Migration[5.2]
  def change
    add_column :bridge_likes, :maintenance_patrol, :string
  end
end
