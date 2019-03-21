class Culvert < BridgeLike

  has_many :culvert_conditions, -> {where.not(culvert_condition_type_id: nil)}, through: :inspections, source: :inspectionible, source_type: 'CulvertCondition'

end
