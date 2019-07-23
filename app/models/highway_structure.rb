class HighwayStructure < TransamAssetRecord
  acts_as :transam_asset, as: :transam_assetible

  actable as: :highway_structurible

  belongs_to :main_span_material_type, class_name: 'StructureMaterialType'
  belongs_to :main_span_design_construction_type, class_name: 'DesignConstructionType'
  belongs_to :highway_structure_type
  
  belongs_to :route_signing_prefix

  belongs_to :structure_status_type

  belongs_to :maintenance_section

  belongs_to :region

  belongs_to :maintenance_responsibility, class_name: 'StructureAgentType'
  belongs_to :owner, class_name: 'StructureAgentType'

  belongs_to :historical_significance_type

  belongs_to :inspection_program
  belongs_to :inspection_zone

  has_many :inspections, foreign_key: :transam_asset_id, dependent: :destroy

  has_many :elements, through: :inspections
  has_many :defects, through: :elements

  has_many :roadways, foreign_key: :transam_asset_id, dependent: :destroy,
           after_add: :reset_lanes, after_remove: :reset_lanes

  callable_by_submodel def self.asset_seed_class_name
    'AssetType'
  end

  FORM_PARAMS = [
      :address1,
      :address2,
      :city,
      :county,
      :state,
      :zip,
      :latitude,
      :longitude,
      :route_signing_prefix_id,
      :route_number,
      :features_intersected,
      :facility_carried,
      :structure_number,
      :location_description,
      :length,
      :inspection_date,
      :fracture_critical_inspection_required,
      :fracture_critical_inspection_frequency,
      :underwater_inspection_required,
      :underwater_inspection_frequency,
      :other_special_inspection_required,
      :other_special_inspection_frequency,
      :fracture_critical_inspection_date,
      :underwater_inspection_date,
      :other_special_inspection_date,
      :is_temporary,
      :structure_status_type_id,
      :region,
      :maintenance_section_id,
      :milepoint,
      :maintenance_responsibility_id,
      :owner_id,
      :approach_roadway_width,
      :region_id,
      :remarks,
      :lanes_on,
      :lanes_under,
      :historical_significance_type_id,
      :highway_structure_type_id
  ]

  CLEANSABLE_FIELDS = [

  ]

  SEARCHABLE_FIELDS = [

  ]

  #-----------------------------------------------------------------------------
  #
  # Class Methods
  #
  #-----------------------------------------------------------------------------

  def self.allowable_params
    FORM_PARAMS
  end

  def self.default_map_renderer_attr
    :calculated_condition
  end

  # this method gets copied from the transam asset level because sometimes start at this base
  def self.very_specific
    klass = self.all
    assoc = klass.column_names.select{|col| col.end_with? 'ible_type'}.first
    assoc_arr = Hash.new
    assoc_arr[assoc] = nil
    t = klass.distinct.where.not(assoc_arr).pluck(assoc)

    while t.count == 1 && assoc.present?
      id_col = assoc[0..-6] + '_id'
      klass = t.first.constantize.where(id: klass.pluck(id_col))
      assoc = klass.column_names.select{|col| col.end_with? 'ible_type'}.first
      if assoc.present?
        assoc_arr = Hash.new
        assoc_arr[assoc] = nil
        t = klass.distinct.where.not(assoc_arr).pluck(assoc)
      end
    end

    return klass
  end

  #-----------------------------------------------------------------------------
  #
  # Instance Methods
  #
  #-----------------------------------------------------------------------------

  def reset_lanes(roadway)
    update_attributes(lanes_on: roadways.on.sum(:lanes),
                      lanes_under: roadways.under.sum(:lanes))
  end
  
  def dup
    super.tap do |new_asset|
      new_asset.transam_asset = self.transam_asset.dup
    end
  end

  def as_json(options={})
    super(options).tap do |json|
      json.merge! acting_as.as_json(options)
      ["organization", "owner", "structure_status_type", "region", "maintenance_section"].each do |field|
        json.merge! field => self.send(field).to_s
      end
      json
    end
  end

  def inspection_frequency
    active_inspection&.inspection_frequency
  end

  def active_inspection
    inspections.where.not(state: 'final').ordered.first
  end

  def last_closed_inspection
    inspections.where(state: 'final').ordered.first
  end

  def open_inspection
    if inspections.where.not(state: 'final').count > 0
      Inspection.get_typed_inspection(inspections.where.not(state: 'final').first)
    elsif inspections.count > 0
      old_insp = Inspection.get_typed_inspection(last_closed_inspection)
      new_insp = old_insp.deep_clone include: {elements: :defects}, except: [:object_key, :guid, :state, :event_datetime, :weather, :temperature, :calculated_inspection_due_date, :qc_inspector_id, :qa_inspector_id, :routine_report_submitted_at, {elements: [:guid, {defects: [:object_key, :guid]}]}]

      old_insp.elements.where(id: old_insp.elements.distinct.pluck(:parent_element_id)).each do |old_parent_elem|
        new_parent_elem = new_insp.elements.select{|e| e.object_key == old_parent_elem.object_key}.first
        new_insp.elements.select{|e| e.parent_element_id == old_parent_elem.id}.each do |kopy_element|
          kopy_element.parent = new_parent_elem
        end
      end
      new_insp.elements.each do |elem|
        # set inspection id for defects
        elem.defects.each do |defect|
          defect.inspection = new_insp
        end

        elem.object_key = nil
      end

      new_insp.state = 'open'
      
      new_insp.inspection_frequency = old_insp.inspection_frequency
      if new_insp.inspection_frequency && old_insp.calculated_inspection_due_date
        new_insp.calculated_inspection_due_date = (old_insp.calculated_inspection_due_date + (new_insp.inspection_frequency).months).at_beginning_of_month
      end

      new_insp.save!

      new_insp
    else
      typed_asset = TransamAsset.get_typed_asset(self)
      if eval("defined?(#{typed_asset.class}Condition)")
        (typed_asset.class.to_s + 'Condition').constantize.new(highway_structure: self)
      else
        self.inspections.build
      end
    end

  end

  protected
end
