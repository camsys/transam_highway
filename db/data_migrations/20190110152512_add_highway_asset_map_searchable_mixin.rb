class AddHighwayAssetMapSearchableMixin < ActiveRecord::DataMigration
  def up
    SystemConfigExtension.find_or_create_by(class_name: 'AssetMapSearcher', extension_name: 'HighwayAssetMapSearchable', active: true)
  end

  def down
    SystemConfigExtension.find_by(class_name: 'AssetMapSearcher', extension_name: 'HighwayAssetMapSearchable').destroy
  end
end