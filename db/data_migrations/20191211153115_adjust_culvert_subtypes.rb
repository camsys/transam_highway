class AdjustCulvertSubtypes < ActiveRecord::DataMigration
  def up
    # Update Culvert to Flexibe if needed
    flexible = AssetSubtype.find_by(name: ['Culvert', 'Flexible'])
    flexible.update_attributes(name: 'Flexible', description: 'Flexible Culvert')
    # Add Rigid if needed
    AssetSubtype.find_or_create_by!(name: 'Rigid', description: 'Rigid Culvert', active: true,
                                    asset_type: AssetType.find_by(name: 'Culvert'))
    # Update Culvert DesignConstructionType
    DesignConstructionType.find_by(code: '19')
      .update_attributes(name: 'Culvert', asset_subtype: flexible)
  end
end
