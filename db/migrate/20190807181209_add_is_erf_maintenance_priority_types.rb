class AddIsErfMaintenancePriorityTypes < ActiveRecord::Migration[5.2]
  def change
    if table_exists?(:maintenance_priority_types)
      add_column :maintenance_priority_types, :is_erf, :boolean, after: :is_default
    end
  end
end
