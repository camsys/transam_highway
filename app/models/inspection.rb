class Inspection < InspectionRecord

  has_paper_trail only: [:state], if: Proc.new { |insp| ['assigned', 'final'].include? insp.state }

  actable as: :inspectionible

  after_initialize :set_defaults
  after_save       :remove_inspectors_after_reopen

  include TransamObjectKey

  include TransamWorkflow

  alias_attribute :status, :state

  belongs_to :highway_structure, foreign_key: :transam_asset_id

  belongs_to :organization_type
  belongs_to :assigned_organization, class_name: 'Organization'

  belongs_to :inspection_type_setting
  belongs_to :inspection_type

  belongs_to :inspection_zone

  belongs_to :qc_inspector, class_name: 'User'
  belongs_to :qa_inspector, class_name: 'User'
  belongs_to :inspection_team_leader, class_name: 'User'
  belongs_to :inspection_team_member, class_name: 'User'
  belongs_to :inspection_team_member_alt, class_name: 'User'
  # Inspection may have been updated from an upload
  belongs_to :upload
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
      :status,
      :organization_type_id,
      :assigned_organization_id,
      :inspection_team_leader_id,
      :inspection_team_member_id,
      :inspection_team_member_alt_id,
      :calculated_inspection_due_date,
      :event_datetime,
      :inspection_frequency,
      :description,
      :inspection_trip,
      :inspection_fiscal_year,
      :inspection_month,
      :inspection_quarter,
      :inspection_trip_key,
      :inspection_second_quarter,
      :inspection_second_trip_key,
      :inspection_zone_id,
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

  def self.get_typed_version(version)
    if version.respond_to? :reify
      reified_ver = version.reify(belongs_to: true)
      inspectionible_ver = reified_ver.inspectionible.version&.reify(has_one: true, belongs_to: true, has_many: true) || reified_ver.inspectionible
      return TransamAsset.get_typed_asset(reified_ver.highway_structure).inspection_class.new(inspectionible_ver.attributes)
    else
      return get_typed_inspection(version)
    end
  end

  def self.allowable_params
    FORM_PARAMS
  end

  def self.transam_workflow_transitions
    [
        {event_name: 'make_ready', from_state: 'open', to_state: 'ready', guard: :allowed_to_make_ready, can: :can_make_ready, human_name: 'To Ready'},

        {event_name: 'reopen', from_state: 'ready', to_state: 'open', guard: :allowed_to_reopen, can: :can_make_ready, human_name: 'To Open'},

        {event_name: 'unassign', from_state: 'assigned', to_state: 'ready', can: :can_assign, human_name: 'To Ready'},

        {event_name: 'assign', from_state: ['ready', 'in_field'], to_state: 'assigned', guard: :allowed_to_assign, can: :can_assign, human_name: 'To Assigned'},

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
    ['reopen']
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
      inspection_category: self.inspection_type_setting.present? ? 'Scheduled' : 'Unscheduled'
    }
  end

  def description
    read_attribute(:description).present? ? read_attribute(:description) : inspection_type_setting&.description
  end

  # returns the version of the highway structure when the inspection was finalized
  # if inspection is not yet finalized, just return the highway structure
  def highway_structure_version
    if state == 'final'
      return versions.last.reify(belongs_to: true).highway_structure&.version || versions.last.reify(belongs_to: true).highway_structure
    else
      return highway_structure
    end
  end

  # returns the roadways associated with the highway_structure_version
  # if inspection is not yet finalized, just return the highway structure
  # the method to determine the versions of the associated roadways follows highway_structure.assigned_version_roadways
  # see that method for detailed comments
  def highway_structure_version_roadways
    typed_version = TransamAsset.get_typed_version(highway_structure_version)
    if state == 'final'
      if highway_structure_version.respond_to? :reify
        typed_version.roadways
      else
        time_of_finalization = versions.last.created_at
        results = typed_version.roadways.where('updated_at <= ?', time_of_finalization).to_a

        typed_version.roadways.where('updated_at > ?', time_of_finalization).each do |roadway|
          ver = roadway.versions.where('created_at > ?', time_of_finalization).where.not(event: 'create').order(:created_at).first
          results << ver.reify if ver
        end
        return results
      end
    else
      return highway_structure.roadways
    end
  end

  # ---------------------------------------------------------------------
  #
  # Methods to check logic before workflow transitions
  # Checks conditions (guard) and permissions (can) are met
  #
  # -------------------------------------------------------------------

  def allowed_to_reopen
    assigned_organization.nil?
  end

  def allowed_to_make_ready
    assigned_organization.present?
  end

  def allowed_to_assign
    inspectors.count > 0
  end

  def allowed_to_finalize
    if inspection_type_setting
      last_inspection_date = highway_structure.inspections.where(state: 'final', inspection_type_setting: inspection_type_setting).maximum(:event_datetime)
    else
      last_inspection_date = highway_structure.inspections.where(state: 'final', inspection_type: inspection_type).maximum(:event_datetime)
    end

    inspection_team_leader.present? && event_datetime.present? && (last_inspection_date.nil? || event_datetime > last_inspection_date)
  end

  def can_make_ready(user)
    can_all(user) || (user.has_role?(:manager) && user.organization.organization_type.class_name == 'HighwayAuthority')
  end

  def can_all(user)
    user.has_role?(:admin)
  end

  def can_assign(user)
    can_all(user) || (user.has_role?(:user) && (assigned_organization.try(:users) || []).include?(user))
  end

  def can_sync(user)
    can_all(user) || user.has_role?(:user)
  end

  def can_start(user)
    can_all(user) || inspectors.include?(user)
  end

  def can_submit(user)
    can_all(user) || (user.has_role?(:manager) && user.organization.organization_type.class_name == 'HighwayAuthority')
  end

  def can_finalize(user)
    can_all(user) || inspection_team_leader == user
  end # TEMP

  # called as callback after `finalize` event
  # to open a new inspection
  def open_new_inspection
    if self.inspection_type_setting.present?

      new_insp = InspectionGenerator.new(self.inspection_type_setting).create

      new_insp_elements = {}

      new_insp.elements.each do |elem|
        new_insp_elements[elem.element_definition_id] = [elem.quantity, elem.notes, elem.parent&.element_definition_id]

        elem.defects.pluck("defect_definition_id","condition_state_1_quantity", "condition_state_2_quantity", "condition_state_3_quantity", "condition_state_4_quantity", "total_quantity", "notes").each do |defect|
          new_insp_elements[elem.element_definition_id] << { defect[0] => defect[1..-1] }
        end
      end

      # update all other open inspections
      self.highway_structure.inspections.where(state: ['open', 'ready']).where.not(id: new_insp.id).each do |insp|
        insp = Inspection.get_typed_inspection(insp)

        (insp.class.attribute_names.map{|x| x.to_sym} + Inspection.attribute_names.map{|x| x.to_sym} - [:id, :object_key, :guid, :state, :event_datetime, :weather, :temperature, :calculated_inspection_due_date, :qc_inspector_id, :qa_inspector_id, :routine_report_submitted_at, :organization_type_id, :assigned_organization_id, :inspection_team_leader_id, :inspection_team_member_id, :inspection_team_member_alt_id, :inspection_type_id]).each do |field_name|
          insp.send("#{field_name}=", new_insp.send(field_name))
        end
        insp.save

        insp.elements.each do |elem|
          if new_insp_elements[elem.element_definition_id]
            elem.quantity = new_insp_elements[elem.element_definition_id][0]
            elem.notes = new_insp_elements[elem.element_definition_id][1]
            elem.parent = insp.elements.find_by(element_definition_id: new_insp_elements[elem.element_definition_id][2]) if new_insp_elements[elem.element_definition_id][2].present?
            elem.save

            elem.defects.each do |defect|

              if new_insp_elements[elem.element_definition_id][3][defect.defect_definition_id]
                defect.condition_state_1_quantity = new_insp_elements[elem.element_definition_id][3][defect.defect_definition_id][0]
                defect.condition_state_2_quantity = new_insp_elements[elem.element_definition_id][3][defect.defect_definition_id][1]
                defect.condition_state_3_quantity = new_insp_elements[elem.element_definition_id][3][defect.defect_definition_id][2]
                defect.condition_state_4_quantity = new_insp_elements[elem.element_definition_id][3][defect.defect_definition_id][3]
                defect.total_quantity = new_insp_elements[elem.element_definition_id][3][defect.defect_definition_id][4]
                defect.notes = new_insp_elements[elem.element_definition_id][3][defect.defect_definition_id][5]
                defect.save
              else
                defect.destroy
              end
            end

            # add new defects
            new_insp.elements.find_by(element_definition_id: elem.element_definition_id).defects.where.not(defect_definition_id: elem.defects.select(:defect_definition_id)).each do |defect|
              new_defect = defect.dup
              new_defect.object_key = nil
              new_defect.guid = nil
              new_defect.element = elem
              new_defect.inspection = elem.inspection
              new_defect.save

            end
          else
            elem.destroy
          end
        end

        # add new elements
        new_insp.elements.where.not(element_definition_id: insp.elements.select(:element_definition_id)).each do |elem|
          new_elem = elem.dup
          new_elem.object_key = nil
          new_elem.guid = nil
          new_elem.inspection = insp.inspection
          new_elem.parent = insp.elements.find_by(element_definition_id: elem.parent.element_definition_id) if elem.parent
          new_elem.save
        end
      end

      new_insp
    end

  end

  def updatable?
    (['assigned','draft_report', 'qc_review'].include? state)
  end

  def destroyable?
    ['open', 'ready'].include?(state) && inspection_type_setting.nil?
  end

  def scour_critical_bridge_type_updatable?
    ['submitted', 'qa_review'].include? state
  end

  protected

  def set_defaults

    # this really is for data loaded inspections that might not have an inspection type setting
    # if inspection type != Special, can use inspection type to get setting
    # otherwise find matching description as well
    if self.inspection_type_setting.nil? && self.highway_structure
      if self.inspection_type&.name == 'Special'
        self.inspection_type_setting = self.highway_structure.inspections.where(inspection_type: self.inspection_type, description: self.description).where.not(inspection_type_setting: nil).first&.inspection_type_setting
      else
        self.inspection_type_setting = self.highway_structure.inspections.where(inspection_type: self.inspection_type).where.not(inspection_type_setting: nil).first&.inspection_type_setting
      end
    end

  end

  def remove_inspectors_after_reopen
    if self.assigned_organization.nil?
      self.inspectors.clear
    elsif self.saved_change_to_attribute?(:assigned_organization_id)
      self.inspectors.each do |insp|
        self.inspectors.delete(insp) unless insp.organization_ids.include? self.assigned_organization_id
      end
    end
  end

end
