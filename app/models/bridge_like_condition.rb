class BridgeLikeCondition < InspectionRecord

  has_paper_trail only: Rails.application.config.inspection_audit_changes.map {|x| x.split('.')[0] == self.table_name ? x.split('.')[1] : nil}.compact, on: :update

  acts_as :inspection, as: :inspectionible, dependent: :destroy

  belongs_to :structural_appraisal_rating_type, class_name: 'BridgeAppraisalRatingType'
  belongs_to :deck_geometry_appraisal_rating_type, class_name: 'BridgeAppraisalRatingType'

  belongs_to :waterway_appraisal_rating_type, class_name: 'BridgeAppraisalRatingType'
  belongs_to :approach_alignment_appraisal_rating_type, class_name: 'BridgeAppraisalRatingType'

  belongs_to :operational_status_type
  belongs_to :channel_condition_type
  belongs_to :scour_critical_bridge_type

  belongs_to :railings_safety_type, class_name: 'FeatureSafetyType'
  belongs_to :transitions_safety_type, class_name: 'FeatureSafetyType'
  belongs_to :approach_rail_safety_type, class_name: 'FeatureSafetyType'
  belongs_to :approach_rail_end_safety_type, class_name: 'FeatureSafetyType'

  FORM_PARAMS = [
      :structural_appraisal_rating_type_id,
      :deck_geometry_appraisal_rating_type_id,
      :waterway_appraisal_rating_type_id,
      :approach_alignment_appraisal_rating_type_id,
      :operational_status_type_id,
      :channel_condition_type_id,
      :scour_critical_bridge_type_id,
      :railings_safety_type_id,
      :transitions_safety_type_id,
      :approach_rail_safety_type_id,
      :approach_rail_end_safety_type_id
  ]

  def bridge_like
    TransamAsset.get_typed_asset(highway_structure)
  end

  private



end
