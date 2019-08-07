class AddIsErfMaintenancePriorityTypes < ActiveRecord::Migration[5.2]
  def change
    add_column :maintenance_priority_types, :is_erf, :boolean, after: :is_default
  end
end
