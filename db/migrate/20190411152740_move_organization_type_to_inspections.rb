class MoveOrganizationTypeToInspections < ActiveRecord::Migration[5.2]
  def change
    remove_reference :highway_structures, :organization_type
    add_reference :inspections, :organization_type
  end
end
