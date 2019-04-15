class MoveInspectionFrequencyToInspections < ActiveRecord::Migration[5.2]
  def change
    remove_column :highway_structures, :inspection_frequency
    add_column :inspections, :inspection_frequency, :integer
  end
end
