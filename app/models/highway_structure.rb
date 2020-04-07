class HighwayStructure < TransamAssetRecord
  has_paper_trail

  acts_as :transam_asset, as: :transam_assetible

  actable as: :highway_structurible

  after_initialize :set_defaults
  before_save :pass_nil_struct_num

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

  belongs_to :federal_submission_type

  has_many :inspections, foreign_key: :transam_asset_id, dependent: :destroy
  has_many :inspection_type_settings, foreign_key: :transam_asset_id, dependent: :destroy

  accepts_nested_attributes_for :inspection_type_settings, :reject_if => lambda { |a| a[:frequency_months].blank? && a[:is_required] == "true" }

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
      :inspection_program_id,
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
      :highway_structure_type_id,
      :federal_submission_type_id,
      :inspection_type_settings_attributes => [InspectionTypeSetting.allowable_params]
  ]

  CLEANSABLE_FIELDS = [

  ]

  SEARCHABLE_FIELDS = [

  ]

  DTD_PARAMS = [:historical_significance_type_id, :region_id, :maintenance_section_id, :county, :city]
  RATING_PARAMS = []
  INSPECTOR_PARAMS = [:location_description, :remarks, :lanes_on, :lanes_under, :approach_roadway_width, :length, :asset_subtype_id, ]

  #-----------------------------------------------------------------------------
  #
  # Class Methods
  #
  #-----------------------------------------------------------------------------

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

  def dtd_params
    arr = DTD_PARAMS.dup
    a = self.specific

    while a.try(:specific).present? && a.specific != a
      arr << a.class::DTD_PARAMS.dup if defined? a.class::DTD_PARAMS
      a = a.specific
    end

    arr << a.class::DTD_PARAMS.dup if defined? a.class::DTD_PARAMS

    return arr.flatten
  end

  def rating_params
    arr = RATING_PARAMS.dup
    a = self.specific

    while a.try(:specific).present? && a.specific != a
      arr << a.class::RATING_PARAMS.dup if defined? a.class::RATING_PARAMS
      a = a.specific
    end

    arr << a.class::RATING_PARAMS.dup if defined? a.class::RATING_PARAMS

    return arr.flatten
  end

  def inspector_params
    arr = INSPECTOR_PARAMS.dup
    a = self.specific

    while a.try(:specific).present? && a.specific != a
      arr << a.class::INSPECTOR_PARAMS.dup if defined? a.class::INSPECTOR_PARAMS
      a = a.specific
    end

    arr << a.class::INSPECTOR_PARAMS.dup if defined? a.class::INSPECTOR_PARAMS

    return arr.flatten
  end

  def inspection_class
    Inspection
  end

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

  def inspection_date
    last_closed_inspection&.event_datetime&.to_date
  end

  def inspection_frequency
    active_inspection&.inspection_frequency
  end

  def active_inspection
    inspections.where(inspection_type: InspectionType.find_by(name: 'Routine')).where.not(state: 'final').ordered.first || inspections.where(inspection_type: InspectionType.find_by(name: 'Routine'), state: 'final').ordered.first
  end

  def last_closed_inspection
    inspections.where(state: 'final').ordered.first
  end

  def assigned_version_roadways
    typed_version = TransamAsset.get_typed_version(assigned_version)
    if assigned_version.respond_to? :reify
      return typed_version.roadways
    elsif assigned_inspection_version.present?
      time_of_assignment = assigned_inspection_version.created_at
      results = typed_version.roadways.where('updated_at <= ?', time_of_assignment).to_a

      typed_version.roadways.where('updated_at > ?', time_of_assignment).each do |roadway|
        ver = roadway.versions.where('created_at > ?', time_of_assignment).where.not(event: 'create').order(:created_at).first
        results << ver.reify if ver
      end
      return results
    end
  end

  def assigned_version
    return assigned_inspection_version&.reify(belongs_to: true)&.highway_structure&.version || assigned_inspection_version&.reify(belongs_to: true)&.highway_structure
  end

  def assigned_inspection_version
    if inspections.where.not(state: ['open', 'ready', 'final']).count > 0
      # we know inspections only have versions for assigned and final so we take the first one which will be an assigned
      # in case from data load the first one might be a state after assigned
      ver = PaperTrail::Version.where(item: inspections.where.not(state: ['open', 'ready', 'final'])).where('object_changes LIKE ?', "%state%").where('object_changes LIKE ?', "%assigned%").order(:created_at).last
      if ver.nil?
        ver = PaperTrail::Version.where(item: inspections.where.not(state: ['open', 'ready', 'final'])).where('object_changes LIKE ?', "%state%").order(:created_at).first
      end

      return ver
    end
  end

  protected

  def set_defaults
    self.calculated_condition ||= "unknown"
  end

  def pass_nil_struct_num
    self[:structure_number] = nil if self[:structure_number].blank?
  end
end
