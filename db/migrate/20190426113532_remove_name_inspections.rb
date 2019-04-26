class RemoveNameInspections < ActiveRecord::Migration[5.2]
  def change
    remove_column :inspections, :name
  end
end
