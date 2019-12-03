class AddMiscStructureAssetTypeSubtype < ActiveRecord::DataMigration
  def up
    AssetType.create!(name: 'Miscellaneous Structure', description: 'Miscellaneous Structure', class_name: 'MiscStructure', display_icon_name: 'fa fa-map-signs', map_icon_name: 'blueIcon', active: true)

    a = AssetSubtype.new(name: 'Miscellaneous Structure', description: 'Miscellaneous Structure', active: true)
    a.asset_type = AssetType.find_by(name: 'Miscellaneous Structure')
    a.save!
  end

  def down
    AssetSubtype.find_by(name: 'Miscellaneous Structure').destroy!
    AssetType.find_by(name: 'Miscellaneous Structure').destroy!
  end
end