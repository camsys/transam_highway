class RoadbedTransamGuidSystemConfigExtension < ActiveRecord::DataMigration
  def up
    SystemConfigExtension.create!(class_name: 'Roadbed', extension_name: 'TransamGuid',
                                  engine_name: 'highway', active: true)
    SystemConfigExtension.create!(class_name: 'RoadbedLine', extension_name: 'TransamGuid',
                                  engine_name: 'highway', active: true)
  end
end