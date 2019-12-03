class MiscStructure < Bridge
  default_scope { where(asset_subtype: AssetSubtype.joins(:asset_type).where(asset_types: {class_name: 'MiscStructure'})) }
  def inspection_class
    BridgeCondition
  end
end
