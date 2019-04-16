class RemoveTransamGuidExtensionBridgeLikeConditions < ActiveRecord::DataMigration
  def up
    ext = SystemConfigExtension.find_by(class_name: 'BridgeLikeCondition', extension_name: 'TransamGuid')
    ext.destroy! if ext
  end
end