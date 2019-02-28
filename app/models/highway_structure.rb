class HighwayStructure < TransamAssetRecord
  acts_as :transam_asset, as: :transam_assetible

  actable as: :highway_structurible

  belongs_to :route_signing_prefix

  belongs_to :structure_status_type

  belongs_to :maintenance_section

  belongs_to :region

  belongs_to :maintenance_responsiblity, class_name: 'StructureAgentType'
  belongs_to :owner, class_name: 'StructureAgentType'

  has_many :inspections, foreign_key: :transam_asset_id, dependent: :destroy

  has_many :elements, through: :inspections
  has_many :defects, through: :elements

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
      :structure_number,
      :location_description,
      :length,
      :inspection_date,
      :inspection_frequency,
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
      :approach_roadway_width
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

  def calculated_condition
    'unknown'
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
end
