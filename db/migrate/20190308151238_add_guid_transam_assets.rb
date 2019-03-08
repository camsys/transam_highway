class AddGuidTransamAssets < ActiveRecord::Migration[5.2]
  def change
    add_column :transam_assets, :guid, :string, after: :object_key
    add_column :inspections, :guid, :string, after: :object_key
    add_column :bridge_conditions, :guid, :string, after: :object_key
    add_column :elements, :guid, :string, after: :object_key
    add_column :defects, :guid, :string, after: :object_key
    add_column :images, :guid, :string, after: :object_key
    add_column :documents, :guid, :string, after: :object_key
  end
end
