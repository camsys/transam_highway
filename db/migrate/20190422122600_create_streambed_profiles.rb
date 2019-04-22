class CreateStreambedProfiles < ActiveRecord::Migration[5.2]
  def change
    create_table :streambed_profiles do |t|
      if ActiveRecord::Base.configurations[Rails.env]['adapter'].include?('mysql2')
        t.string :guid, limit: 36
      else
        t.uuid :guid
      end

      t.references :inspection, foreign_key: true
      t.datetime :date
      t.decimal :water_level

      t.timestamps
    end
  end
end
