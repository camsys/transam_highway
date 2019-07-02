class AddHighwayFieldsToImages < ActiveRecord::Migration[5.2]
  def change
    add_column :images, :condition_state, :string
    add_column :images, :is_primary, :boolean
  end
end
