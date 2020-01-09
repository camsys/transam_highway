class Bridge < BridgeLike

  belongs_to :deck_structure_type
  belongs_to :wearing_surface_type
  belongs_to :membrane_type
  belongs_to :deck_protection_type

  has_many :bridge_conditions, through: :inspections, source: :inspectionible, source_type: 'BridgeLikeCondition', class_name: 'BridgeCondition'

  default_scope { where(asset_subtype: AssetSubtype.joins(:asset_type).where(asset_types: {class_name: ['Bridge', 'MiscStructure']})) }

  scope :bridge_only, -> { where(asset_subtype: AssetSubtype.joins(:asset_type).where(asset_types: {class_name: 'Bridge'})) }
  #-----------------------------------------------------------------------------
  #
  # Instance Methods
  #
  #-----------------------------------------------------------------------------  

end
