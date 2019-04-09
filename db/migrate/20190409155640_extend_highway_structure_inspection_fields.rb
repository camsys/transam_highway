class ExtendHighwayStructureInspectionFields < ActiveRecord::Migration[5.2]
  def change
    add_reference :highway_structures, :inspection_program
    add_reference :highway_structures, :organization_type
    add_reference :inspections, :qc_inspector
    add_reference :inspections, :qa_inspector
    add_column :inspections, :routine_report_submitted_at, :datetime
    add_column :highway_structures, :inspection_trip, :string
  end
end
