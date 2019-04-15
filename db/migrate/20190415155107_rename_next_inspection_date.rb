class RenameNextInspectionDate < ActiveRecord::Migration[5.2]
  def change
    rename_column :inspections, :next_inspection_date, :calculated_inspection_due_date
  end
end
