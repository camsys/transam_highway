class AddLanesHighwayStructures < ActiveRecord::Migration[5.2]
  def change
    add_column :highway_structures, :lanes_on, :integer
    add_column :highway_structures, :lanes_under, :integer
  end
end
