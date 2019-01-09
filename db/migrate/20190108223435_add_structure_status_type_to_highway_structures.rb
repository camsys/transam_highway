class AddStructureStatusTypeToHighwayStructures < ActiveRecord::Migration[5.2]
  def change
    add_reference :highway_structures, :structure_status_type
  end
end
