class AddStructureNumberToHighwayStructure < ActiveRecord::Migration[5.2]
  def change
    add_column :highway_structures, :structure_number, :string
    add_index :highway_structures, :structure_number, unique: true
  end
end
