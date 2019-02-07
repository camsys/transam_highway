class BridgeCondition < ApplicationRecord

  acts_as :inspection, as: :inspectionible, dependent: :destroy

  belongs_to :deck_condition_rating_type, class_name: 'BridgeConditionRatingType'
  belongs_to :superstructure_condition_rating_type, class_name: 'BridgeConditionRatingType'
  belongs_to :substructure_condition_rating_type, class_name: 'BridgeConditionRatingType'

  belongs_to :structural_appraisal_rating_type, class_name: 'BridgeAppraisalRatingType'
  belongs_to :deck_geometry_appraisal_rating_type, class_name: 'BridgeAppraisalRatingType'
  belongs_to :underclearance_appraisal_rating_type, class_name: 'BridgeAppraisalRatingType'
  belongs_to :waterway_appraisal_rating_type, class_name: 'BridgeAppraisalRatingType'
  belongs_to :approach_alignment_appraisal_rating_type, class_name: 'BridgeAppraisalRatingType'

  belongs_to :operational_status_type
  belongs_to :channel_condition_type
  belongs_to :scour_critical_bridge_type

  belongs_to :railings_safety_type, class_name: 'FeatureSafetyType'
  belongs_to :transitions_safety_type, class_name: 'FeatureSafetyType'
  belongs_to :approach_rail_safety_type, class_name: 'FeatureSafetyType'
  belongs_to :approach_rail_end_safety_type, class_name: 'FeatureSafetyType'

end
