class CreateColumnTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :column_types do |t|
      t.string :name
      t.string :code
      t.boolean :active

      t.timestamps
    end
  end
end
