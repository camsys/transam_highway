class AddMaintenanceSectionToHighwayStructures < ActiveRecord::Migration[5.2]
  def change
    add_reference :highway_structures, :maintenance_section
  end
end
