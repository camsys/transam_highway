class Inspection < InspectionRecord

  actable as: :inspectionible

  include TransamObjectKey

  include TransamWorkflow

  alias_attribute :status, :state

  belongs_to :highway_structure, foreign_key: :transam_asset_id

  belongs_to :organization_type
  belongs_to :assigned_organization, class_name: 'Organization'

  belongs_to :inspection_type


  belongs_to :inspection_zone

  belongs_to :qc_inspector, class_name: 'User'
  belongs_to :qa_inspector, class_name: 'User'
  belongs_to :inspection_team_leader, class_name: 'User'
  belongs_to :inspection_team_member, class_name: 'User'
  belongs_to :inspection_team_member_alt, class_name: 'User'
  has_and_belongs_to_many :inspectors, class_name: 'User', join_table: 'inspections_users'

  has_many :elements, dependent: :destroy
  has_many :parent_elements,  -> { where(parent_element_id: nil) }, class_name: 'Element'

  has_one :streambed_profile, dependent: :destroy
  has_many :roadbed_lines, dependent: :destroy
  
  # Each asset has zero or more images. Images are deleted when the asset is deleted
  has_many    :images,      :as => :imagable,       :dependent => :destroy

  scope :ordered, -> { order(event_datetime: :desc) }
  scope :final,  -> { where(state: 'final') }
  scope :not_final, -> { where.not(state: 'final') }

  FORM_PARAMS = [
      :transam_asset_id,
      :inspection_type_id,
      :name,
      :event_datetime,
      :temperature,
      :weather,
      :notes,
      :organization_type_id,
      :assigned_organization_id,
      :inspection_team_leader_id,
      :inspection_team_member_id,
      :inspection_team_member_alt_id,
      :calculated_inspection_due_date,
      :event_datetime,
      :inspection_frequency,
      :description,
      :inspector_ids => []
  ]

  def self.get_typed_inspection(inspection)
    if inspection
      if inspection.specific
        inspection = inspection.specific

        typed_asset = TransamAsset.get_typed_asset(inspection.highway_structure)
        inspection = inspection.becomes(typed_asset.inspection_class)
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

        {event_name: 'reopen', from_state: 'ready', to_state: 'open', guard: :allowed_to_reopen, can: :can_make_ready, human_name: 'To Open'},

        {event_name: 'unassign', from_state: 'assigned', to_state: 'ready', guard: :allowed_to_unassign, can: :can_assign, human_name: 'To Ready'},

        {event_name: 'assign', from_state: ['ready', 'in_field'], to_state: 'assigned', guard: :allowed_to_assign, can: :can_assign, human_name: 'To Assigned'},

        {event_name: 'schedule', from_state: 'open', to_state: 'assigned', guard: :allowed_to_schedule, can: :can_schedule, human_name: 'To Assigned'},

        {event_name: 'send_to_field', from_state: ['assigned', 'in_progress'], to_state: 'in_field', can: :can_sync, human_name: 'To In Field'},

        {event_name: 'start', from_state: ['in_field', 'draft_report'], to_state: 'in_progress', can: {in_field: :can_sync, draft_report: :can_start}, human_name: 'To In Progress'},

        {event_name: 'complete', from_state: ['in_field', 'draft_report'], to_state: 'field_work_complete', can: {in_field: :can_sync, draft_report: :can_start}, human_name: 'To Field Work Complete'},

        {event_name: 'draft', from_state: ['in_progress', 'field_work_complete', 'qc_review', 'qa_review'], to_state: 'draft_report', can: {in_progress: :can_start, field_work_complete: :can_start, qc_review: :can_start, qa_review: :can_submit}, human_name: 'To Draft Report'},

        {event_name: 'qc', from_state: ['draft_report', 'submitted'], to_state: 'qc_review', can: :can_start, human_name: 'To QC Review', to_state_human_name: 'QC Review'},

        {event_name: 'submit', from_state: ['qc_review', 'qa_review'], to_state: 'submitted', can: {qc_review: :can_start, qa_review: :can_submit}, human_name: 'To Submitted'},

        {event_name: 'qa', from_state: ['submitted','signature_ready'], to_state: 'qa_review', can: :can_submit, human_name: 'To QA Review', to_state_human_name: 'QA Review'},

        {event_name: 'sign', from_state: ['submitted', 'qa_review'], to_state: 'signature_ready', can: :can_submit, human_name: 'To Ready for Signature'},

        {event_name: 'finalize', from_state: 'signature_ready', to_state: 'final', guard: :allowed_to_finalize, can: :can_finalize, after: :open_new_inspection, human_name: 'To Final'},
    ]
  end

  # transitions that should happen automatically when you update an inspection (through the detail page) as long as all the conditions are meh
  def self.automatic_transam_workflow_transitions
    ['reopen', 'unassign']
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
      inspection_trip: inspection_trip,

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

  # ---------------------------------------------------------------------
  #
  # Methods to check logic before workflow transitions
  # Checks conditions (guard) and permissions (can) are met
  #
  # -------------------------------------------------------------------

  def allowed_to_schedule
    allowed_to_make_ready && allowed_to_assign && calculated_inspection_due_date.present?
  end

  def allowed_to_reopen
    assigned_organization.nil?
  end

  def allowed_to_make_ready
    assigned_organization.present?
  end

  def allowed_to_unassign
    inspectors.count == 0
  end

  def allowed_to_assign
    inspectors.count > 0
  end

  def allowed_to_finalize
    typed_inspection = Inspection.get_typed_inspection(self)
    inspection_team_leader.present? && event_datetime.present? && event_datetime > highway_structure.inspection_date && typed_inspection.has_required_photos?

  end

  def can_schedule
    true
  end

  def can_make_ready(user)
    can_all(user) || user.has_role?(:manager)
  end

  def can_all(user)
    user.has_role?(:super_manager) || user.has_role?(:admin)
  end
  
  def can_assign(user)
    can_all(user) || (user.has_role?(:inspector) && (assigned_organization.try(:users) || []).include?(user))
  end

  def can_sync(user)
    can_all(user) || user.has_role?(:inspector)
  end

  def can_start(user)
    can_all(user) || inspectors.include?(user)
  end

  def can_submit(user)
    can_all(user) || user.has_role?(:manager)
  end
  
  def can_finalize(user)
    can_all(user) || inspection_team_leader == user
  end # TEMP

  # called as callback after `finalize` event
  # to open a new inspection
  def open_new_inspection
    new_insp = InspectionGenerator.new(InspectionTypeSetting.find_by(inspection_type: self.inspection_type, highway_structure: self.highway_structure)).create

    new_insp.create_streambed_profile if new_insp.streambed_profile.nil?

    new_insp_elements = {}

    new_insp.elements.each do |elem|
      new_insp_elements[elem.element_definition_id] = [elem.quantity, elem.notes]

      elem.defects.pluck("defect_definition_id","condition_state_1_quantity", "condition_state_2_quantity", "condition_state_3_quantity", "condition_state_4_quantity", "total_quantity", "notes").each do |defect|
        new_insp_elements[elem.element_definition_id] << { defect[0] => defect[1..-1] }
      end
    end

    # update all other open inspections
    self.highway_structure.inspections.where.not(state: 'final', id: new_insp.id).each do |insp|
      (Inspection.attribute_names.map{|x| x.to_sym} - [:id, :object_key, :guid, :state, :event_datetime, :weather, :temperature, :calculated_inspection_due_date, :qc_inspector_id, :qa_inspector_id, :routine_report_submitted_at, :organization_type_id, :assigned_organization_id, :inspection_team_leader_id, :inspection_team_member_id, :inspection_team_member_alt_id]).each do |field_name|
        insp.send("#{field_name}=", new_insp.send(field_name))
      end
      insp.save

      insp.elements.each do |elem|
        elem.quantity = new_insp_elements[elem.element_definition_id][0]
        elem.notes = new_insp_elements[elem.element_definition_id][1]
        elem.save

        elem.defect.each do |defect|
          defect.condition_state_1_quantity = new_insp_elements[elem.element_definition_id][2][defect.defect_definition_id][0]
          defect.condition_state_2_quantity = new_insp_elements[elem.element_definition_id][2][defect.defect_definition_id][1]
          defect.condition_state_3_quantity = new_insp_elements[elem.element_definition_id][2][defect.defect_definition_id][2]
          defect.condition_state_4_quantity = new_insp_elements[elem.element_definition_id][2][defect.defect_definition_id][3]
          defect.total_quantity = new_insp_elements[elem.element_definition_id][2][defect.defect_definition_id][4]
          defect.notes = new_insp_elements[elem.element_definition_id][2][defect.defect_definition_id][5]
          defect.save
        end
      end
    end

    new_insp

  end

  def updatable?
    (['draft_report', 'qc_review'].include? state)
  end

  protected

end
