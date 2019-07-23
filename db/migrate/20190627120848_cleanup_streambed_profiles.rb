class CleanupStreambedProfiles < ActiveRecord::Migration[5.2]
  def change
    add_column :streambed_profiles, :object_key, :string, after: :id, null: false
    add_column :streambed_profile_points, :object_key, :string, after: :id, null: false
    add_reference :streambed_profiles, :transam_asset, index: true, after: :object_key

    add_index(:streambed_profile_points, [:streambed_profile_id, :distance], unique: true, name: 'streambed_profile_id_distance_uniq_idx')
  end
end
