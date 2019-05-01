class BridgeCondition < BridgeLikeCondition

  belongs_to :deck_condition_rating_type, class_name: 'BridgeConditionRatingType'
  belongs_to :superstructure_condition_rating_type, class_name: 'BridgeConditionRatingType'
  belongs_to :substructure_condition_rating_type, class_name: 'BridgeConditionRatingType'

  belongs_to :underclearance_appraisal_rating_type, class_name: 'BridgeAppraisalRatingType'

  after_save :update_calculated_condition

  FORM_PARAMS = [
    :deck_condition_rating_type_id,
    :superstructure_condition_rating_type_id,
    :substructure_condition_rating_type_id,
    :underclearance_appraisal_rating_type_id
  ]

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

  def update_calculated_condition
    if self.saved_change_to_attribute?(:deck_condition_rating_type_id) ||
        self.saved_change_to_attribute?(:superstructure_condition_rating_type_id) ||
        self.saved_change_to_attribute?(:substructure_condition_rating_type_id)
      # get bridge
      br = TransamAsset.get_typed_asset(self.highway_structure)
      br.try(:set_calculated_condition!) if br
    end
  end

end
