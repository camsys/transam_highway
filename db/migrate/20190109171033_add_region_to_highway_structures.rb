class AddRegionToHighwayStructures < ActiveRecord::Migration[5.2]
  def change
    add_reference :highway_structures, :region
  end
end
