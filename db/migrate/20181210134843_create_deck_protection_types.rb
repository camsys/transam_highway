class CreateDeckProtectionTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :deck_protection_types do |t|
      t.string :name
      t.string :code
      t.boolean :active

      t.timestamps
    end
  end
end
