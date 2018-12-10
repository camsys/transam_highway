class Bridge < TransamAssetRecord
  acts_as :highway_structure, as: :highway_structurible

  belongs_to :operational_status_type
  belongs_to :main_span_material_type, class_name: 'StructureMaterialType'
  belongs_to :main_span_design_construction_type, class_name: 'DesignConstructionType'
  belongs_to :approach_spans_material_type, class_name: 'StructureMaterialType'
  belongs_to :approach_spans_design_construction_type, class_name: 'DesignConstructionType'
  belongs_to :deck_condition_rating_type, class_name: 'BridgeConditionRatingType'
  belongs_to :superstructure_condition_rating_type, class_name: 'BridgeConditionRatingType'
  belongs_to :substructure_condition_rating_type, class_name: 'BridgeConditionRatingType'
  belongs_to :channel_condition_type
  
  belongs_to :structural_appraisal_rating_type, class_name: 'BridgeAppraisalRatingType'
  belongs_to :deck_geometry_appraisal_rating_type, class_name: 'BridgeAppraisalRatingType'
  belongs_to :underclearance_appraisal_rating_type, class_name: 'BridgeAppraisalRatingType'
  belongs_to :waterway_appraisal_rating_type, class_name: 'BridgeAppraisalRatingType'
  belongs_to :approach_alignment_appraisal_rating_type, class_name: 'BridgeAppraisalRatingType'
  belongs_to :strahnet_designation_type
  belongs_to :deck_structure_type
  belongs_to :wearing_surface_type
  belongs_to :membrane_type
  belongs_to :deck_protection_type
  belongs_to :scour_critical_bridge_type

  FORM_PARAMS = [
    :facility_carried,
    :operational_status_type_id,
    :main_span_material_type_id,
    :main_span_design_construction_type_id,
    :approach_spans_material_type_id,
    :approach_spans_design_construction_type_id,
    :num_spans_main,
    :num_spans_approach,
    :deck_condition_rating_type_id,
    :superstructure_condition_rating_type_id,
    :substructure_condition_rating_type_id,
    :channel_condition_type_id,
    :structural_appraisal_rating_type_id,
    :deck_geometry_appraisal_rating_type_id,
    :underclearance_appraisal_rating_type_id,
    :waterway_appraisal_rating_type_id,
    :approach_alignment_appraisal_rating_type_id,
    :border_bridge_state,
    :border_bridge_pcnt_responsibility,
    :border_bridge_structure_number,
    :strahnet_designation_type_id,
    :deck_structure_type_id,
    :wearing_surface_type_id,
    :membrane_type_id,
    :deck_protection_type_id,
    :scour_critical_bridge_type_id
  ]

  CLEANSABLE_FIELDS = [

  ]

  SEARCHABLE_FIELDS = [

  ]

  def dup
    super.tap do |new_asset|
      new_asset.highway_structure = self.highway_structure.dup
    end
  end
  
end
