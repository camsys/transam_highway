class CreateHighwayStructureTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :highway_structure_types do |t|
      t.boolean :active
      t.string :code
      t.string :name
      t.string :description
      t.string :structure_class
    end
  end
end
