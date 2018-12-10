class CreateDeckStructureTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :deck_structure_types do |t|
      t.string :name
      t.string :code
      t.boolean :active
    end
  end
end
