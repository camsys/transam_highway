class AddStructureKeyToHighwayStructure < ActiveRecord::Migration[5.2]
  def change
    add_column :highway_structures, :structure_key, :string
  end
end
