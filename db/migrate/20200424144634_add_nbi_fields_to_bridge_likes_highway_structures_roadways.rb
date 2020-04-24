class AddNbiFieldsToBridgeLikesHighwayStructuresRoadways < ActiveRecord::Migration[5.2]
  def change
    add_column :bridge_likes, :parallel_structure, :string
    add_column :bridge_likes, :is_nbis_length, :boolean
    add_column :highway_structures, :reconstructed_year, :integer
    add_reference :roadways, :federal_lands_highway_type, foreign_key: true
  end
end
