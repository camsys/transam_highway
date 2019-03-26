class AddNextInspectionDate < ActiveRecord::Migration[5.2]
  def change
    add_column :highway_structures, :next_inspection_date, :date, after: :inspection_frequency
  end
end
