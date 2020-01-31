class RemoveInspectionDateHighwayStructures < ActiveRecord::Migration[5.2]
  def change
    remove_column :highway_structures, :inspection_date
  end
end
