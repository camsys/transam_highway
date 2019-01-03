class RemoveTimestampsFromMembraneTypes < ActiveRecord::Migration[5.2]
  def change
    remove_column :membrane_types, :created_at, :string
    remove_column :membrane_types, :updated_at, :string
  end
end
