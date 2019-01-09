class CreateStructureStatusTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :structure_status_types do |t|
      t.string :name
      t.string :code
      t.boolean :active
    end
  end
end
