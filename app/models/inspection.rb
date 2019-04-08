class Inspection < ApplicationRecord

  actable as: :inspectionible

  include TransamObjectKey

  include TransamWorkflow

  belongs_to :highway_structure, foreign_key: :transam_asset_id

  belongs_to :assigned_organization, class_name: 'Organization'

  belongs_to :inspection_type

  has_and_belongs_to_many :inspectors, class_name: 'User', join_table: 'inspections_users'

  has_many :elements, dependent: :destroy

  scope :ordered, -> { order(event_datetime: :desc) }

  def self.get_typed_inspection(inspection)
    if inspection
      if inspection.specific
        inspection = inspection.specific

        typed_asset = TransamAsset.get_typed_asset(inspection.highway_structure)
        inspection = inspection.becomes((typed_asset.class.to_s + 'Condition').constantize) if defined?((typed_asset.class.to_s + 'Condition').constantize)
      end

      inspection
    end
  end

  def self.allowable_params
    [
      :name,
      :event_datetime,
      :temperature,
      :weather,
      :notes,
      :assigned_organization_id
    ]
  end

  def self.transam_workflow_transitions
    [
        {event_name: 'make_ready', from_state: 'open', to_state: 'ready', guard: :allowed_to_make_ready, can: :can_make_ready},

        {event_name: 'assign', from_state: 'ready', to_state: 'assigned', guard: :allowed_to_assign, can: :can_assign},

        {event_name: 'send_to_field', from_state: 'assigned', to_state: 'in_field'},

        {event_name: 'reassign', from_state: ['in_field', 'draft_report', 'draft_complete', 'qc_reviewed', 'qa_reviewed', 'submitted'], to_state: 'ready', can: {in_field: :can_start, draft_report: :can_start, draft_complete: :can_qc, qc_reviewed: :can_qa, qa_reviewed: :can_submit, submitted: :can_finalize}},

        {event_name: 'revert', from_state: ['in_field', 'draft_complete', 'qc_reviewed', 'qa_reviewed', 'submitted'], to_state: 'draft_report', can: {in_field: :can_start,  draft_complete: :can_qc, qc_reviewed: :can_qa, qa_reviewed: :can_submit, submitted: :can_finalize}},

        {event_name: 'finish', from_state: ['in_field', 'draft_report'], to_state: 'draft_complete', can: :can_start},

        {event_name: 'qc_review', from_state: 'draft_complete', to_state: 'qc_reviewed', can: :can_qc},

        {event_name: 'qa_review', from_state: 'qc_reviewed', to_state: 'qa_reviewed', can: :can_qa},
        {event_name: 'qc_submit', from_state: ['qc_reviewed', 'qa_reviewed'], to_state: 'submitted', guard: :allowed_to_submit, can: :can_submit},

        {event_name: 'finalize', from_state: 'submitted', to_state: 'final', can: :can_finalize},

    ]
  end

  def allowed_to_make_ready
    assigned_organization.present?
  end

  def as_json(options={})
    #TODO: any options to process
    structure = TransamAsset.get_typed_asset self.highway_structure
    {
      to_global_id: self.to_global_id.to_s,
      structure_object_key: structure.object_key,
      highway_structurible_type: structure.class.name,
      transam_assets_asset_tag: structure.asset_tag,
      location_description: structure.location_description,
      owner: structure.owner&.to_s,
      calculated_condition: structure.calculated_condition&.titleize,

      object_key: object_key
    }
  end
  
  def can_make_ready(user)
    user.try(:is_inspection_admin)
  end

  def allowed_to_assign
    inspectors.count > 0
  end
  
  def can_assign(user)
    user.try(:is_inspection_editor)
  end

  def can_start(user)
    inspectors.include? user
  end

  def can_qc(user)
    user.try(:is_qc_reviewer)
  end
  
  def can_qa(user)
    user.try(:is_qa_reviewer)
  end

  def allowed_to_submit
    # can skip QA
    true
  end
  
  def can_submit(user)
    user.try(:is_submitter)
  end
  
  def can_finalize(user)
    user.try(:is_finalizer)
  end

end
