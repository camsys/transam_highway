class AddHighwayStructureTypeToHighwayStructures < ActiveRecord::Migration[5.2]
  def change
    add_reference :highway_structures, :highway_structure_type
  end
end
