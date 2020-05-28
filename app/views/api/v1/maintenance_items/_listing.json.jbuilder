json.id maintenance_item.guid
json.highway_structure_id maintenance_item.try(:transam_asset).try(:guid)
json.priority maintenance_item.priority_type&.name
json.status maintenance_item.state.titleize
json.location maintenance_item.maintenance_events.first.maintenance_activity_type&.maintenance_activity_category_subtype&.name
json.recommendation maintenance_item.maintenance_events.first.maintenance_activity_type&.name
json.(maintenance_item, :notes, :order_date)
json.timeline maintenance_item.maintenance_events.first.due_date
json.date_completed maintenance_item.maintenance_events.first.event_date