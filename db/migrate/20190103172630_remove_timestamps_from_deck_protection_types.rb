class RemoveTimestampsFromDeckProtectionTypes < ActiveRecord::Migration[5.2]
  def change
    remove_column :deck_protection_types, :created_at, :string
    remove_column :deck_protection_types, :updated_at, :string
  end
end
