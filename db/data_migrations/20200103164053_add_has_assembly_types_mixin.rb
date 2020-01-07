class AddHasAssemblyTypesMixin < ActiveRecord::DataMigration
  def up
    SystemConfigExtension.find_or_create_by(class_name: 'AssetType', extension_name: 'HasAssemblyTypes', active: true)
  end

  def down
    SystemConfigExtension.find_by(class_name: 'AssetType', extension_name: 'HasAssemblyTypes').destroy
  end
end
