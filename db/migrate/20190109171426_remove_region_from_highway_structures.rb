class RemoveRegionFromHighwayStructures < ActiveRecord::Migration[5.2]
  def change
    remove_column :highway_structures, :region, :integer
  end
end
