class MoveInspectionProgramBackHighwayStructures < ActiveRecord::Migration[5.2]
  def change
    remove_reference :inspections, :inspection_program
    add_reference :highway_structures, :inspection_program
  end
end
