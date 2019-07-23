class AddObjectKeyAndGuidIndexes < ActiveRecord::Migration[5.2]
  def change
    add_index :defects, :object_key
    add_index :defects, :guid
    add_index :documents, :guid
    add_index :elements, :object_key
    add_index :elements, :guid
    add_index :images, :guid
    add_index :inspections, :object_key
    add_index :inspections, :guid
    add_index :roadways, :object_key
    add_index :roadways, :guid
    add_index :streambed_profiles, :object_key
    add_index :streambed_profiles, :guid
    add_index :streambed_profile_points, :object_key
    add_index :streambed_profile_points, :guid
    add_index :transam_assets, :object_key
    add_index :transam_assets, :guid
  end
end
