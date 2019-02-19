class CreateFieldReferenceTables < ActiveRecord::Migration[5.2]
  def change
    create_table :field_reference_tables do |t|
      t.string :name
      t.string :label
      t.string :number
      t.string :table
      t.string :abbr
      t.string :short_desc
      t.text :long_desc

      t.timestamps
    end
  end
end
