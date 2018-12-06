class CreateDesignConstructionTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :design_construction_types do |t|
      t.string :code
      t.string :name
      t.boolean :active
    end
  end
end
