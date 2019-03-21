class Bridge < BridgeLike

  belongs_to :deck_structure_type
  belongs_to :wearing_surface_type
  belongs_to :membrane_type
  belongs_to :deck_protection_type

  has_many :bridge_conditions, through: :inspections, source: :inspectionible, source_type: 'BridgeLikeCondition', class_name: 'BridgeCondition'


end
