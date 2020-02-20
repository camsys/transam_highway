class DefectLocationTransamGuidSystemConfigExtension < ActiveRecord::DataMigration
  def up
    SystemConfigExtension.create!(class_name: 'DefectLocation', extension_name: 'TransamGuid',
                                  engine_name: 'highway', active: true)
    DefectLocation.where(guid: nil).each do |sp|
      sp.update(guid: SecureRandom.uuid)
    end
  end
end
