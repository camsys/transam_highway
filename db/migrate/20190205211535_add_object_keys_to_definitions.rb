class AddObjectKeysToDefinitions < ActiveRecord::Migration[5.2]
  def change
    add_column :element_definitions, :object_key, :string, null: false, limit: 12, first: true
    add_column :defect_definitions, :object_key, :string, null: false, limit: 12, first: true
  end
end
