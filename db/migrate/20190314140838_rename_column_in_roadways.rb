class RenameColumnInRoadways < ActiveRecord::Migration[5.2]
  def change
    rename_column :roadways, :on_national_higway_system, :on_national_highway_system
  end
end
