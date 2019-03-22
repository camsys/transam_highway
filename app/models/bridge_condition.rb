class BridgeCondition < BridgeLikeCondition

  belongs_to :deck_condition_rating_type, class_name: 'BridgeConditionRatingType'
  belongs_to :superstructure_condition_rating_type, class_name: 'BridgeConditionRatingType'
  belongs_to :substructure_condition_rating_type, class_name: 'BridgeConditionRatingType'

  belongs_to :underclearance_appraisal_rating_type, class_name: 'BridgeAppraisalRatingType'

end
