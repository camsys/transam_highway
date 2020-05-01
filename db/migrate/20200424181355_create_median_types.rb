class CreateMedianTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :median_types do |t|
      t.string :code
      t.string :name
      t.string :description
      t.boolean :active

      t.timestamps
    end
  end
end
