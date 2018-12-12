class RemoveStructureNumberFromHighwayStructures < ActiveRecord::Migration[5.2]
  def change
    remove_column :highway_structures, :structure_number, :string
  end
end
