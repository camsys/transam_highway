class RoadwayTransamGuidSystemConfigExtension < ActiveRecord::DataMigration
  def up
    SystemConfigExtension.create!(class_name: 'Roadway', extension_name: 'TransamGuid',
                                  engine_name: 'highway', active: true)
  end
end