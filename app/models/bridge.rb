class Bridge < TransamAssetRecord
  acts_as :highway_structure, as: :highway_structurible


  belongs_to :main_span_material_type, class_name: 'StructureMaterialType'
  belongs_to :main_span_design_construction_type, class_name: 'DesignConstructionType'
  belongs_to :approach_spans_material_type, class_name: 'StructureMaterialType'
  belongs_to :approach_spans_design_construction_type, class_name: 'DesignConstructionType'

  belongs_to :strahnet_designation_type
  belongs_to :deck_structure_type
  belongs_to :wearing_surface_type
  belongs_to :membrane_type
  belongs_to :deck_protection_type

  has_many :bridge_conditions, through: :inspections, source: :inspectionible, source_type: 'BridgeCondition'


  FORM_PARAMS = [
    :facility_carried,
    :main_span_material_type_id,
    :main_span_design_construction_type_id,
    :approach_spans_material_type_id,
    :approach_spans_design_construction_type_id,
    :num_spans_main,
    :num_spans_approach,
    :border_bridge_state,
    :border_bridge_pcnt_responsibility,
    :border_bridge_structure_number,
    :strahnet_designation_type_id,
    :deck_structure_type_id,
    :wearing_surface_type_id,
    :membrane_type_id,
    :deck_protection_type_id
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
      #
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
    is_new = bridge.new_record?
    if is_new
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
      facility_carried: bridge_hash['FACILITY'],
      main_span_material_type: StructureMaterialType.find_by(code: bridge_hash['MATERIALMAIN']),
      main_span_design_construction_type: DesignConstructionType.find_by(code: bridge_hash['DESIGNMAIN']),
      approach_spans_material_type: StructureMaterialType.find_by(code: bridge_hash['MATERIALAPPR']),
      approach_spans_design_construction_type: DesignConstructionType.find_by(code: bridge_hash['DESIGNAPPR']),
      num_spans_main: bridge_hash['MAINSPANS'].to_i,
      num_spans_approach: bridge_hash['APPSPANS'].to_i,
      deck_structure_type: DeckStructureType.find_by(code: bridge_hash['DKSTRUCTYP']),
      wearing_surface_type: WearingSurfaceType.find_by(code: bridge_hash['DKSURFTYPE']),
      membrane_type: MembraneType.find_by(code: bridge_hash['DKMEMBTYPE']),
      deck_protection_type: DeckProtectionType.find_by(code: bridge_hash['DKPROTECT'])
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
    # NBI 5A
    # NBI 5B
    optional[:route_signing_prefix] = RouteSigningPrefix.find_by(code: roadway_hash['KIND_HWY'])
    # NBI 5D
    optional[:route_number] = roadway_hash['ROUTENUM']
    
    # Process lat/lon
    lat = bridge_hash['PRECISE_LAT'].to_f
    lon = bridge_hash['PRECISE_LON'].to_f
    optional[:latitude] = lat unless lat == -1
    optional[:longitude] = lon * -1 unless lon == -1
    
    # process milepost
    optional[:milepoint] = roadway_hash['KMPOST'].to_f * 0.621371
    
    # process district
    # split into region and maintenance section
    district = bridge_hash['DISTRICT']
    optional[:region] = Region.find_by(code: district[0])
    optional[:maintenance_section] = MaintenanceSection.find_by(code: district[1])

    # process county & city/placecode
    optional[:county] = District.find_by(code: bridge_hash['COUNTY'],
                                         district_type: DistrictType.find_by(name: 'County')).name
    optional[:city] = District.find_by(code: bridge_hash['PLACECODE'],
                                       district_type: DistrictType.find_by(name: 'Place')).name
    bridge.attributes = optional
    # Save
    bridge.save!

    # process inspection data
    last_inspection_date = Date.new
    unless is_new
      # delete all existing inspection data and refresh
      bridge.bridge_conditions.each(&:destroy)
    end
    
    inspections = {}
    hash['inspevnt'].each do |i_hash|
      date = Date.parse(i_hash['INSPDATE'])
      if date > last_inspection_date
        last_inspection_date = date 
        optional[:inspection_frequency] = i_hash['BRINSPFREQ']
      end
      # inspection type
      type = InspectionType.find_by(code: i_hash['INSPTYPE'])
      
      inspection = BridgeCondition.new(event_datetime: date, name: bridge.asset_tag,
                                       inspection_type: type, notes: i_hash['NOTES'])

      bridge.inspections << inspection
      inspections[i_hash['INSPKEY']] = inspection

      # safety ratings
      {railings_safety_type_id: 'RAILRATING',
       transitions_safety_type_id: 'TRANSRATIN',
       approach_rail_safety_type_id: 'ARAILRATIN',
       approach_rail_end_safety_type_id: 'AENDRATING'}.each do |attribute, key|
        inspection[attribute] = FeatureSafetyType.where(code: i_hash[key]).pluck(:id).first
      end

      inspection.operational_status_type = OperationalStatusType.find_by(code: i_hash['OPPOSTCL'])
      inspection.channel_condition_type = ChannelConditionType.find_by(code: i_hash['CHANRATING'])
      inspection.scour_critical_bridge_type = ScourCriticalBridgeType.find_by(code: i_hash['SCOURCRIT'])
      
      # condition ratings
      {deck_condition_rating_type_id: 'DKRATING',
       superstructure_condition_rating_type_id: 'SUPRATING',
       substructure_condition_rating_type_id: 'SUBRATING'}.each do |attribute, key|
        inspection[attribute] = BridgeConditionRatingType.where(code: i_hash[key]).pluck(:id).first
      end

      # appraisal ratings
      {structural_appraisal_rating_type_id: 'STRRATING',
       deck_geometry_appraisal_rating_type_id: 'DECKGEOM',
       underclearance_appraisal_rating_type_id: 'UNDERCLR',
       waterway_appraisal_rating_type_id: 'WATERADEQ',
       approach_alignment_appraisal_rating_type_id: 'APPRALIGN'}.each do |attribute, key|
        inspection[attribute] = BridgeAppraisalRatingType.where(code: i_hash[key]).pluck(:id).first
      end
      
      inspection.save!
    end
    optional[:inspection_date] = last_inspection_date

    elements = {}
    
    # process element inspection data
    # hash['pon_elem_insp'].each do |e_hash|
    if false
      inspection = inspections[e_hash['INSPKEY']]
      elem_parent_def = ElementDefinition.find_by(number: e_hash['ELEM_PARENT_KEY'].to_i)

      if elem_parent_def
      # Find parent element
        parent_elem = elements[elem_parent_def.number]
        
        # Assume defect (or MBE)
      # set quantities

      else
        elem_def = ElementDefinition.find_by(number: e_hash['ELEM_KEY'].to_i)
        # Process element
        element = inspection.elements.build(element_definition: elem_def,
                                            quantity: e_hash['ELEM_QUANTITY'],
                                            notes: e_hash['ELEM_NOTES'])
        elements[elem_def.number] = element
        
      end
      inspection.save!
    end

    msg
  end
  
  #-----------------------------------------------------------------------------
  #
  # Instance Methods
  #
  #-----------------------------------------------------------------------------  
  def calculated_condition
    bridge_conditions.ordered.first.calculated_condition
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
