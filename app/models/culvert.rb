class Culvert < BridgeLike

  has_many :culvert_conditions, through: :inspections, source: :inspectionible, source_type: 'BridgeLikeCondition', class_name: 'CulvertCondition'

  default_scope { where(asset_subtype: AssetSubtype.joins(:asset_type).where(asset_types: {class_name: 'Culvert'})) }
end
