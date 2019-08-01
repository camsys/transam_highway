class StreambedProfileTransamGuidSystemConfigExtension < ActiveRecord::DataMigration
  def up
    SystemConfigExtension.create!(class_name: 'StreambedProfile', extension_name: 'TransamGuid',
                                  engine_name: 'highway', active: true)
    SystemConfigExtension.create!(class_name: 'StreambedProfilePoint', extension_name: 'TransamGuid',
                                  engine_name: 'highway', active: true)

    StreambedProfile.where(guid: nil).each do |sp|
      sp.update(guid: SecureRandom.uuid)
    end

    StreambedProfilePoint.where(guid: nil).each do |spp|
      spp.update(guid: SecureRandom.uuid)
    end
  end
end