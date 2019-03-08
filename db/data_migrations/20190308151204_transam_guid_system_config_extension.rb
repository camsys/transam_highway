class TransamGuidSystemConfigExtension < ActiveRecord::DataMigration
  def up
    ['TransamAsset', 'Inspection',
    'BridgeCondition',
    'Element',
    'Defect',
    'Image',
    'Document'].each do |class_name|
      SystemConfigExtension.create!(class_name: class_name, extension_name: 'TransamGuid', engine_name: 'highway', active: true)
    end


  end
end