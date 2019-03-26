class RoadwaySeeds < ActiveRecord::DataMigration
  def up
    service_level_types = [
      {active: true, code: '0',	name: 'Other'},
      {active: true, code: '1',	name: 'Mainline'},
      {active: true, code: '2',	name: 'Alternate'},
      {active: true, code: '3',   name: 'Bypass'},
      {active: true, code: '4',	name: 'Spur'},
      {active: true, code: '6',	name: 'Business'},
      {active: true, code: '7',	name: 'Ramp/Wye/Connector'},
      {active: true, code: '8',	name: 'Service/Frontage Road'}
    ]

    functional_classes = [
      {active: true, code: '01',	name: 'Rural Principal Arterial - Interstate'},
      {active: true, code: '02',	name: 'Rural Principal Arterial - Other'},
      {active: true, code: '06',	name: 'Rural Minor Arterial'},
      {active: true, code: '07',	name: 'Rural Major Collector'},
      {active: true, code: '08',	name: 'Rural Minor Collector'},
      {active: true, code: '09',	name: 'Rural Local'},
      {active: true, code: '11',	name: 'Urban Principal Arterial - Interstate'},
      {active: true, code: '12',	name: 'Urban Principal Arterial - Other Freeways or Expressways'},
      {active: true, code: '14',	name: 'Urban Other Principal Arterial'},
      {active: true, code: '16',	name: 'Urban Minor Arterial'},
      {active: true, code: '17',	name: 'Urban Collector'},
      {active: true, code: '19',	name: 'Urban Local'}
    ]

    traffic_direction_types = [
      {active: true, code: '0',	name: 'Highway traffic not carried'},
      {active: true, code: '1',	name: '1-way traffic'},
      {active: true, code: '2',	name: '2-way traffic'},
      {active: true, code: '3',	name: 'One lane bridge for 2-way traffic'}
    ]

    seed_tables = %w{ service_level_types functional_classes traffic_direction_types }

    seed_tables.each do |table_name|
      puts "  Loading #{table_name}"
      data = eval(table_name)
      klass = table_name.classify.constantize
      data.each do |row|
        klass.create!(row)
      end
    end
  end
end