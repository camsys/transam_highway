class AddRegionAndMilepointToHighwayStructures < ActiveRecord::Migration[5.2]
  def change
    add_column :highway_structures, :region, :integer
    add_column :highway_structures, :milepoint, :float
  end
end
