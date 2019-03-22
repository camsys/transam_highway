class Culvert < BridgeLike

  has_many :culvert_conditions, through: :inspections, source: :inspectionible, source_type: 'BridgeLikeCondition', class_name: 'CulvertCondition'

end
