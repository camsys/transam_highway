class ChangeGuidsToUuid < ActiveRecord::Migration[5.2]
  def change
    remove_column :transam_assets, :guid, :string
    remove_column :inspections, :guid, :string
    remove_column :bridge_conditions, :guid, :string
    remove_column :elements, :guid, :string
    remove_column :defects, :guid, :string
    remove_column :images, :guid, :string
    remove_column :documents, :guid, :string

    add_column :transam_assets, :guid, :uuid, after: :object_key
    add_column :inspections, :guid, :uuid, after: :object_key
    add_column :bridge_conditions, :guid, :uuid, after: :id
    add_column :elements, :guid, :uuid, after: :object_key
    add_column :defects, :guid, :uuid, after: :object_key
    add_column :images, :guid, :uuid, after: :object_key
    add_column :documents, :guid, :uuid, after: :object_key
  end
end
