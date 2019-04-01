class AddGuidToBridgeLikeCondition < ActiveRecord::DataMigration
  def up
    SystemConfigExtension.find_or_create_by!(class_name: 'BridgeLikeCondition',
                                             extension_name: 'TransamGuid',
                                             engine_name: 'highway', active: true)
  end
end