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

  after_save :update_calculated_condition

  def calculated_condition
    case [deck_condition_rating_type&.value, superstructure_condition_rating_type&.value,
          substructure_condition_rating_type&.value].compact.min
    when 0..4
      'poor'
    when 5..6
      'fair'
    when 7..9
      'good'
    else
      'unknown'
    end
  end

  def bridge
    highway_structure.very_specific
  end

  private

  def update_calculated_condition
    if self.deck_condition_rating_type_id_changed? || 
      self.superstructure_condition_rating_type_id_changed? ||
      self.substructure_condition_rating_type_id_changed?
      # get bridge
      br = self.highway_structure.try(:very_specific)
      br.try(:set_calculated_condition!) if br
    end
  end

end
