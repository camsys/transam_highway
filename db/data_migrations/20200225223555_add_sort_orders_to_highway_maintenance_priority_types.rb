class AddSortOrdersToHighwayMaintenancePriorityTypes < ActiveRecord::DataMigration
  def up
    orders = {
        'Low': 1,
        'Medium': 2,
        'High': 3,
        'ERF - Blue': 4,
        'ERF - Green': 5,
        'ERF - Yellow': 6,
        'ERF - Red': 7
    }

    orders.each do |p,o|
      MaintenancePriorityType.find_by(name: p).update(sort_order: o)
    end
  end
end