class Bridge < BridgeLike

  has_many :bridge_conditions, -> {where(culvert_condition_type_id: nil)}, through: :inspections, source: :inspectionible, source_type: 'BridgeCondition'


end
