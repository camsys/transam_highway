class MoveNextInspectionDateToInspections < ActiveRecord::Migration[5.2]
  def change
    remove_column :highway_structures, :next_inspection_date
    add_column :inspections, :next_inspection_date, :date, after: :event_datetime
  end
end
