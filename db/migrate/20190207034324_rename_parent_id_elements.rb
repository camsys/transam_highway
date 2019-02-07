class RenameParentIdElements < ActiveRecord::Migration[5.2]
  def change
    rename_column :elements, :parent_id, :parent_element_id
  end
end
