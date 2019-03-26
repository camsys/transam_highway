class AddCulvertTypeAndSubtype < ActiveRecord::DataMigration
  def up
    culvert_type = AssetType.create!({name: 'Culvert', description: 'Culvert', class_name: 'Culvert', display_icon_name: 'fa fa-road', map_icon_name: 'blueIcon', active: true})
    culvert_subtype = AssetSubtype.create!({asset_type:  culvert_type, name: 'Culvert', description: 'Culvert', active: true})
    DesignConstructionType.find_by(code: 19).update_attributes(asset_subtype: culvert_subtype)
  end
end