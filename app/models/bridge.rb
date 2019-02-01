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

  def self.process_upload(io, ext, &block)
    unless ['.xml', '.zip'].include? ext
      return false, "Extension #{ext} should be .xml or .zip"
    end
    successful = true
    msg = ''
    
    if ext == '.zip'
    else
      begin
        msg = create_or_update_from_xml(io, &block)
      rescue TypeError => e
        Rails.logger.warn e.message
        Rails.logger.warn e.backtrace
        return false, e.message
      end
    end
    return successful, msg
  end

  def self.create_or_update_from_xml(io, &block)
    msg = ''
    hash = Hash.from_xml(io)['Pontis_BridgeExport']
    bridge_hash = hash['bridge']
    roadway_hash = hash['roadway']

    asset_tag = bridge_hash['BRKEY']

    bridge = Bridge.find_or_initialize_by(asset_tag: asset_tag)
    required = {}
    if bridge.new_record?
      msg = "Created bridge #{asset_tag}"
      # Set asset required fields
      # determine correct asset_subtype
      asset_subtype = DesignConstructionType.find_by(code: bridge_hash['DESIGNMAIN']).asset_subtype
      required = {
        asset_subtype: asset_subtype,
        organization: Organization.find_by(short_name: 'CDOT'),
        purchase_cost: 0,
        in_service_date: Date.today,
        purchase_date: Date.today,
        purchased_new: true
      }
      bridge.attributes = required
    else
      msg = "Updated bridge #{asset_tag}"
    end
    
    # Extract relevant fields
    optional = {
      # TransamAsset
      state: 'CO',
      manufacture_year: bridge_hash['YEARBUILT'],
      # HighwayStructure
      features_intersected: bridge_hash['FEATINT'],
      location_description: bridge_hash['LOCATION'],
      description: bridge_hash['LOCATION'],
      length: bridge_hash['LENGTH'],
      is_temporary: (bridge_hash['TEMPSTRUC'] == 'T'),
      structure_status_type: StructureStatusType.find_by(code: bridge_hash['BRIDGE_STATUS']),
      # Bridge
      facility_carried: bridge_hash['FACILITY']
    }

    # Process roadway fields
    if roadway_hash.is_a?(Array)
      # There are multiple roadway sections in the XML, find the first "valid" section
      roadway_hash.each do |h|
        # KIND_HWY = ! seems to be a reliable indicator of invalid section
        unless h['KIND_HWY'] == '!'
          roadway_hash = h
          break
        end
      end
    end
    optional[:route_signing_prefix] = RouteSigningPrefix.find_by(code: roadway_hash['KIND_HWY'])
    optional[:route_number] = roadway_hash['ROUTENUM']
    
    # Process lat/lon
    lat = bridge_hash['PRECISE_LAT'].to_f
    lon = bridge_hash['PRECISE_LON'].to_f
    optional[:latitude] = lat unless lat == -1
    optional[:longitude] = lon * -1 unless lon == -1
    
    # process inspection data
    inspection_date = Date.new
    hash['inspevnt'].each do |i|
      date = Date.parse(i['INSPDATE'])
      if date > inspection_date
        inspection_date = date 
        optional[:inspection_frequency] = i['BRINSPFREQ']
        optional[:deck_condition_rating_type] =
          BridgeConditionRatingType.find_by(code: i['DKRATING'])
        optional[:superstructure_condition_rating_type] =
          BridgeConditionRatingType.find_by(code: i['SUPRATING'])
        optional[:substructure_condition_rating_type] =
          BridgeConditionRatingType.find_by(code: i['SUBRATING'])
      end
    end
    optional[:inspection_date] = inspection_date

    # process milepost
    optional[:milepoint] = roadway_hash['KMPOST'].to_f * 0.621371
    
    # process district
    # split into region and maintenance section
    district = bridge_hash['DISTRICT']
    optional[:region] = Region.find_by(code: district[0])
    optional[:maintenance_section] = MaintenanceSection.find_by(code: district[1])
    # process inspection date
    inspection_date = Date.new
    hash['inspevnt'].each do |i|
      date = Date.parse(i['INSPDATE'])
      inspection_date = date if date > inspection_date
    end
    optional[:inspection_date] = inspection_date
    
    bridge.attributes = optional
    # Save
    bridge.save!

    msg
  end
  
  #-----------------------------------------------------------------------------
  #
  # Instance Methods
  #
  #-----------------------------------------------------------------------------  
  def calculated_condition
    case [deck_condition_rating_type&.value, superstructure_condition_rating_type&.value,
          substructure_condition_rating_type&.value].compact.min 
    when 0..4 
      'poor' 
    when 5..6 
      'fair' 
    when 7..9 
      'good' 
    end 
  end
  
  def dup
    super.tap do |new_asset|
      new_asset.highway_structure = self.highway_structure.dup
    end
  end
  
  def as_json(options={})
    super(options).tap do |json|
      json.merge! acting_as.as_json(options)
      json.merge! "bridge_type" => self.asset_subtype.to_s
      json
    end
  end
end
