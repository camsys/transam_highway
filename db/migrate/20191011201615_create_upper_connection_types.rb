class CreateUpperConnectionTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :upper_connection_types do |t|
      t.string :name
      t.string :code
      t.boolean :active

      t.timestamps
    end
  end
end
