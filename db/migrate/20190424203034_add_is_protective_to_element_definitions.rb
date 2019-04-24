class AddIsProtectiveToElementDefinitions < ActiveRecord::Migration[5.2]
  def change
    add_column :element_definitions, :is_protective, :boolean, default: false
  end
end
