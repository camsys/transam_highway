class CreateStreambedProfilePoints < ActiveRecord::Migration[5.2]
  def change
    create_table :streambed_profile_points do |t|
      t.uuid :guid
      t.references :streambed_profile, foreign_key: true
      t.decimal :distance
      t.distance :value

      t.timestamps
    end
  end
end
