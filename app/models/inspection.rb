class Inspection < InspectionRecord

  actable as: :inspectionible

  include TransamObjectKey

  include TransamWorkflow

  alias_attribute :status, :state

  belongs_to :highway_structure, foreign_key: :transam_asset_id

  belongs_to :organization_type
  belongs_to :assigned_organization, class_name: 'Organization'

  belongs_to :inspection_type

  belongs_to :qc_inspector, class_name: 'User'
  belongs_to :qa_inspector, class_name: 'User'
  has_and_belongs_to_many :inspectors, class_name: 'User', join_table: 'inspections_users'

  has_many :elements, dependent: :destroy
  has_many :parent_elements,  -> { where(parent_element_id: nil) }, class_name: 'Element'

  has_one :streambed_profile

  # Each asset has zero or more images. Images are deleted when the asset is deleted
  has_many    :images,      :as => :imagable,       :dependent => :destroy

  scope :ordered, -> { order(event_datetime: :desc) }

  FORM_PARAMS = [
      :name,
      :event_datetime,
      :temperature,
      :weather,
      :notes,
      :organization_type_id,
      :assigned_organization_id,
      :inspector_ids => []
  ]

  def self.get_typed_inspection(inspection)
    if inspection
      if inspection.specific
        inspection = inspection.specific

        typed_asset = TransamAsset.get_typed_asset(inspection.highway_structure)
        inspection = inspection.becomes((typed_asset.class.to_s + 'Condition').constantize) if eval("defined?(#{typed_asset.class}Condition)")
      end

      inspection
    end
  end

  def self.allowable_params
    FORM_PARAMS
  end

  def self.transam_workflow_transitions
    [
        {event_name: 'make_ready', from_state: 'open', to_state: 'ready', guard: :allowed_to_make_ready, can: :can_make_ready, human_name: 'To Ready'},

        {event_name: 'assign', from_state: 'ready', to_state: 'assigned', guard: :allowed_to_assign, can: :can_assign, human_name: 'To Assigned'},

        {event_name: 'send_to_field', from_state: 'assigned', to_state: 'in_field', human_name: 'To In Field'},

        {event_name: 'start', from_state: 'in_field', to_state: 'in_progress', can: :can_start, human_name: 'To In Progress'},
        {event_name: 'revert', from_state: 'draft_report', to_state: 'in_progress', can: :can_start, human_name: 'To In Progress'},

        {event_name: 'reassign', from_state: 'in_field', to_state: 'ready', can: :can_start, human_name: 'To Ready'},

        {event_name: 'edit', from_state: ['in_progress', 'qc_review'], to_state: 'draft_report', can: :can_start, human_name: 'To Draft Report'},

        {event_name: 'finish', from_state: ['draft_report', 'qa_review'], to_state: 'qc_review', can: {draft_report: :can_start, qa_review: :can_qc}, human_name: 'To QC Review', to_state_human_name: 'QC Review'},

        {event_name: 'qc', from_state: ['qc_review', 'submitted'], to_state: 'qa_review', can: {qc_review: :can_qc, submitted: :can_qa}, human_name: 'To QA Review', to_state_human_name: 'QA Review'},

        {event_name: 'qa', from_state: ['qc_review', 'qa_review'], to_state: 'submitted', can: {qc_review: :can_qc, qa_review: :can_qa}, human_name: 'To Submitted'},

        {event_name: 'finalize', from_state: 'submitted', to_state: 'final', can: :can_finalize, after: :open_new_inspection, human_name: 'To Final'},

    ]
  end


  def allowed_to_make_ready
    assigned_organization.present?
  end

  def as_json(options={})
    #TODO: any options to process

    #TODO:
    # Inspection Zone (87), Inspection Category
    structure = TransamAsset.get_typed_asset self.highway_structure
    insp = Inspection.get_typed_inspection(self)
    {
      to_global_id: self.to_global_id.to_s,
      structure_object_key: structure.object_key,
      highway_structurible_type: structure.class.name,
      transam_assets_asset_tag: structure.asset_tag,
      location_description: structure.location_description,
      owner: structure.owner&.to_s,
      inspection_program: structure.inspection_program&.to_s,
      inspection_trip: structure.inspection_trip,

      object_key: object_key,
      event_datetime: self.event_datetime,
      calculated_condition: insp.try(:calculated_condition)&.titleize,
      calculated_inspection_due_date: self.calculated_inspection_due_date,
      state: self.state&.titleize,
      organization_type: self.organization_type&.to_s,
      assigned_organization: self.assigned_organization&.to_s,
      inspection_type: self.inspection_type&.to_s,
      routine_report_submitted_at: self.routine_report_submitted_at,
      inspectors: self.inspectors.map(&:name).join(', '),
      inspection_category: 'Scheduled' # Hard-code for now
    }
  end
  
  def can_make_ready(user)
    true # TEMP
  end

  def allowed_to_assign
    inspectors.count > 0
  end
  
  def can_assign(user)
    true # TEMP
  end

  def can_start(user)
    inspectors.include? user
  end

  def can_qc(user)
    true # TEMP
  end
  
  def can_qa(user)
    true # TEMP
  end
  
  def can_finalize(user)
    true
  end # TEMP

  # called as callback after `finalize` event
  # to open a new inspection
  def open_new_inspection
    new_insp = self.highway_structure.open_inspection

    new_insp.create_streambed_profile unless new_insp.streambed_profile.present?

    new_insp

  end

  def updatable?
    state != 'final'
  end

  protected

end
