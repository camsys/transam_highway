class AddHighwayMaintenancePriorityTypes < ActiveRecord::DataMigration
  def up
    if ActiveRecord::Base.connection.table_exists?(:maintenance_priority_types)
      MaintenancePriorityType.destroy_all

      maintenance_priority_types = [
          {:active => 1, :is_default => 0, :is_erf => 0, :name => 'Low',     :description => 'Lowest priority.'},
          {:active => 1, :is_default => 1, :is_erf => 0, :name => 'Normal',  :description => 'Normal priority.'},
          {:active => 1, :is_default => 0, :is_erf => 0, :name => 'High',    :description => 'Highest priority.'},
          {:active => 1, :is_default => 0, :is_erf => 1, :name => 'ERF - Blue',    :description => 'ERF - Blue.'},
          {:active => 1, :is_default => 0, :is_erf => 1, :name => 'ERF - Green',    :description => 'ERF - Green.'},
          {:active => 1, :is_default => 0, :is_erf => 1, :name => 'ERF - Yellow',    :description => 'ERF - Yellow.'},
          {:active => 1, :is_default => 0, :is_erf => 1, :name => 'ERF - Red',    :description => 'ERF - Red.'},
      ]

      maintenance_priority_types.each{|m| MaintenancePriorityType.create!(m)}
    end
  end
end