class HighwayMaintenanceServiceOrdersController < MaintenanceServiceOrdersController
  def index
    super
  end

  def get_status_filters
    {
      "pending" => @maintenance_service_orders.joins(:maintenance_events).where('maintenance_service_orders.state = ? AND maintenance_events.due_date > ?', 'pending', Date.today.beginning_of_month),
      "overdue" => @maintenance_service_orders.joins(:maintenance_events).where('maintenance_service_orders.state != ? AND maintenance_events.due_date < ?', 'completed', Date.today.beginning_of_month),
      "completed" => @maintenance_service_orders.joins(:maintenance_events).where('maintenance_service_orders.state = ?', 'completed')
    }
  end
end