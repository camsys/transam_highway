class CreateStreambedProfilePoints < ActiveRecord::Migration[5.2]
  def change
    create_table :streambed_profile_points do |t|
      if ActiveRecord::Base.configurations[Rails.env]['adapter'].include?('mysql2')
        t.string :guid, limit: 36
      else
        t.uuid :guid
      end

      t.references :streambed_profile, foreign_key: true
      t.decimal :distance
      t.distance :value

      t.timestamps
    end
  end
end
