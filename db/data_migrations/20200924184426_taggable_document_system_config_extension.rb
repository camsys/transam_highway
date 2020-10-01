class TaggableDocumentSystemConfigExtension < ActiveRecord::DataMigration
  def up
    SystemConfigExtension.create!(class_name: 'Document', extension_name: 'TaggableDocument', engine_name: 'highway', active: true)
  end
end
