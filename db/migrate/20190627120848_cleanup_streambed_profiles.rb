class CleanupStreambedProfiles < ActiveRecord::Migration[5.2]
  def change
    add_column :streambed_profiles, :object_key, :string, after: :id, null: false
    add_column :streambed_profile_points, :object_key, :string, after: :id, null: false
    add_reference :streambed_profiles, :transam_asset, index: true, after: :object_key
  end
end
