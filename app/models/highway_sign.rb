class HighwaySign < AncillaryStructure
  default_scope { where(asset_subtype: AssetSubtype.joins(:asset_type).where(asset_types: {class_name: 'HighwaySign'})) }
end
