class AddPaperTrailMixinTransamAsset < ActiveRecord::DataMigration
  def up
    SystemConfigExtension.create!(class_name: 'TransamAsset', extension_name: 'PaperTrailAssetAware', engine_name: 'highway', active: true)
  end

  def down
    SystemConfigExtension.find_by(extension_name: 'PaperTrailAssetAware').destroy!
  end
end