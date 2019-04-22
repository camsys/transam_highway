class CreateStreambedProfiles < ActiveRecord::Migration[5.2]
  def change
    create_table :streambed_profiles do |t|
      t.uuid :guid
      t.references :inspection, foreign_key: true
      t.datetime :date
      t.decimal :water_level

      t.timestamps
    end
  end
end
