class CulvertCondition < BridgeLikeCondition

  belongs_to :culvert_condition_type

  validates :culvert_condition_type, presence: true

end
