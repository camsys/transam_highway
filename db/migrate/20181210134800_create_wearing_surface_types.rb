class CreateWearingSurfaceTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :wearing_surface_types do |t|
      t.string :name
      t.string :code
      t.string :description
      t.boolean :active

      t.timestamps
    end
  end
end
