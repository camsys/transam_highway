class BridgeLike < TransamAssetRecord
  acts_as :highway_structure, as: :highway_structurible


  belongs_to :main_span_material_type, class_name: 'StructureMaterialType'
  belongs_to :main_span_design_construction_type, class_name: 'DesignConstructionType'
  belongs_to :approach_spans_material_type, class_name: 'StructureMaterialType'
  belongs_to :approach_spans_design_construction_type, class_name: 'DesignConstructionType'

  belongs_to :strahnet_designation_type
  belongs_to :service_on_type
  belongs_to :service_under_type
  belongs_to :bridge_toll_type
  belongs_to :design_load_type
  belongs_to :operating_rating_method_type, class_name: 'LoadRatingMethodType'
  belongs_to :inventory_rating_method_type, class_name: 'LoadRatingMethodType'
  belongs_to :bridge_posting_type
  belongs_to :vertical_reference_feature_below, class_name: 'ReferenceFeatureType'
  belongs_to :lateral_reference_feature_below, class_name: 'ReferenceFeatureType'

  has_many :bridge_like_conditions, through: :inspections, source: :inspectionible, source_type: 'BridgeLikeCondition'


  FORM_PARAMS = [
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
    :deck_protection_type_id,
    :service_on_type_id,
    :service_under_type_id,
    :bridge_toll_type_id,
    :max_span_length,
    :left_curb_sidewalk_width,
    :right_curb_sidewalk_width,
    :roadway_width,
    :deck_width,
    :min_vertical_clearance_above,
    :vertical_reference_feature_below_id,
    :min_vertical_clearance_below,
    :lateral_reference_feature_below_id,
    :min_lateral_clearance_below_right,
    :min_lateral_clearance_below_left,
    :design_load_type_id,
    :operating_rating_method_type_id,
    :operating_rating,
    :inventory_rating_method_type_id,
    :inventory_rating,
    :bridge_posting_type_id
  ]

  CLEANSABLE_FIELDS = [

  ]

  SEARCHABLE_FIELDS = [

  ]

  NDIGITS = 3
  
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
    class_name = nil
    
    if ext == '.zip'
      #
    else
      begin
        successful, msg, class_name = create_or_update_from_xml(io, &block)
      rescue TypeError, NoMethodError => e
        if Rails.env.sandbox?
          Rails.logger.warn e.message
          Rails.logger.warn e.backtrace.join("/n")
          return false, e.message
        else
          raise
        end
      end
    end
    return successful, msg, class_name
  end

  # NOTE: some of this is CDOT specific and should be refactored specifically to that
  # application.
  def self.create_or_update_from_xml(io, &block)
    msg = ''
    hash = Hash.from_xml(io)['Pontis_BridgeExport']
    bridge_hash = hash['bridge']
    roadway_hash = hash['roadway']

    # Structure Key, NBI 8A
    asset_tag = bridge_hash['BRKEY']

    # Process Structure Class and Structure Type
    struct_class_code = bridge_hash['USERKEY3']
    struct_type_code = hash['userbrdg']&.fetch('structtype')

    case struct_type_code
    when 'TLS'
      struct_type_code = 'TLA'
    when 'TS'
      struct_class_code = 'BRIDGE'
    when 'CA'
      struct_type_code = 'CAC' if struct_class_code == 'CULVERT'
    when 'CAC', 'CBC', 'PCBC', 'SAC'
      struct_class_code == 'CULVERT'
    end
    
    # Structure Class, NBI 24 is 'Bridge' or 'Culvert'
    bridgelike = nil
    case struct_class_code
    when 'BRIDGE'
      bridgelike = Bridge.find_or_initialize_by(asset_tag: asset_tag)
    when 'CULVERT'
      bridgelike = Culvert.find_or_initialize_by(asset_tag: asset_tag)
    else
      msg = "Skipping processing of Structure Class: #{struct_class_code}"
      return false, msg
    end
      
    required = {}
    is_new = bridgelike.new_record?
    if is_new
      msg = "Created #{struct_class_code} #{asset_tag}"
      # Set asset required fields
      # determine correct asset_subtype, NBI 43D
      # standardize format
      design_code = bridge_hash['DESIGNMAIN'].rjust(2, '0')
      design_type = DesignConstructionType.find_by(code: design_code)
      if design_type
        asset_subtype = design_type.asset_subtype
        # Sanity check
        unless asset_subtype.asset_type.name.upcase == struct_class_code
          return false, "#{asset_tag}: main span construction type #{design_type} does not math structure class #{struct_class_code}"
        end
      elsif struct_class_code == 'BRIDGE'
        asset_subtype = DesignConstructionType.find_by(name: 'Other').asset_subtype
      elsif struct_class_code == 'CULVERT'
        asset_subtype = DesignConstructionType.find_by(name: 'Culvert').asset_subtype
      end
                        
                        
      required = {
        asset_subtype: asset_subtype,
        organization: Organization.find_by(short_name: 'CDOT'),
        purchase_cost: 0,
        in_service_date: Date.today,
        purchase_date: Date.today,
        purchased_new: true
      }
      bridgelike.attributes = required
    else
      msg = "Updated #{struct_class_code} #{asset_tag}"
    end
    
    # Extract relevant fields
    optional = {
      # TransamAsset, NBI 1, 8, 27
      state: 'CO',
      structure_number: bridge_hash['STRUCT_NUM'],
      manufacture_year: bridge_hash['YEARBUILT'],
      # HighwayStructure, NBI 6A, 7, 9, 21, 22, 23, 37, 43A, 43B, 43C, 103
      features_intersected: bridge_hash['FEATINT'],
      facility_carried: bridge_hash['FACILITY'],
      location_description: bridge_hash['LOCATION'],
      description: bridge_hash['LOCATION'],
      structure_status_type: StructureStatusType.find_by(code: bridge_hash['BRIDGE_STATUS']),
      historical_significance_type: HistoricalSignificanceType.find_by(code: bridge_hash['HISTSIGN']),
      main_span_material_type: StructureMaterialType.find_by(code: bridge_hash['MATERIALMAIN']),
      main_span_design_construction_type: DesignConstructionType.find_by(code: bridge_hash['DESIGNMAIN'].rjust(2, '0')),
      highway_structure_type: HighwayStructureType.find_by(code: struct_type_code),
      is_temporary: (bridge_hash['TEMPSTRUC'] == 'T'),
      # BridgeLike, NBI 20, 31, 42A, 42B, 44A, 44B, 45, 46, 48, 49, 50A, 50B, 51, 52, 53, 54A, 54B,
      # 55A, 55B, 56, 63, 64, 65, 66, 70, 107, 108A, 108B, 108C
      bridge_toll_type: BridgeTollType.find_by(code: bridge_hash['TOLLFAC']),
      design_load_type: DesignLoadType.find_by(code: bridge_hash['DESIGNLOAD']),
      service_on_type: ServiceOnType.find_by(code: bridge_hash['SERVTYPON']),
      service_under_type: ServiceUnderType.find_by(code: bridge_hash['SERVTYPUND']),
      approach_spans_material_type: StructureMaterialType.find_by(code: bridge_hash['MATERIALAPPR']),
      approach_spans_design_construction_type: DesignConstructionType.find_by(code: bridge_hash['DESIGNAPPR'].rjust(2, '0')),
      num_spans_main: bridge_hash['MAINSPANS'].to_i,
      num_spans_approach: bridge_hash['APPSPANS'].to_i,
      max_span_length: Uom.convert(bridge_hash['MAXSPAN'].to_f, Uom::METER, Uom::FEET).round(NDIGITS),
      length: Uom.convert(bridge_hash['LENGTH'].to_f, Uom::METER, Uom::FEET).round(NDIGITS),
      left_curb_sidewalk_width: Uom.convert(bridge_hash['LFTCURBSW'].to_f, Uom::METER, Uom::FEET).round(NDIGITS),
      right_curb_sidewalk_width: Uom.convert(bridge_hash['RTCURBSW'].to_f, Uom::METER, Uom::FEET).round(NDIGITS),
      roadway_width: Uom.convert(bridge_hash['ROADWIDTH'].to_f, Uom::METER, Uom::FEET).round(NDIGITS),
      deck_width: Uom.convert(bridge_hash['DECKWIDTH'].to_f, Uom::METER, Uom::FEET).round(NDIGITS),
      min_vertical_clearance_above: Uom.convert(bridge_hash['VCLROVER'].to_f, Uom::METER, Uom::FEET).round(NDIGITS),
      vertical_reference_feature_below: ReferenceFeatureType.find_by(code: bridge_hash['REFVUC']),
      min_vertical_clearance_below: Uom.convert(bridge_hash['VCLRUNDER'].to_f, Uom::METER, Uom::FEET).round(NDIGITS),

      lateral_reference_feature_below: ReferenceFeatureType.find_by(code: bridge_hash['REFHUC']),
      min_lateral_clearance_below_right: Uom.convert(bridge_hash['HCLRURT'].to_f, Uom::METER, Uom::FEET).round(NDIGITS),
      min_lateral_clearance_below_left: Uom.convert(bridge_hash['HCLRULT'].to_f, Uom::METER, Uom::FEET).round(NDIGITS),
      operating_rating_method_type: LoadRatingMethodType.find_by(code: bridge_hash['ORTYPE'].to_s),
      operating_rating: Uom.convert(bridge_hash['ORLOAD'].to_f, Uom::TONNE, Uom::SHORT_TON).round(NDIGITS),
      inventory_rating_method_type: LoadRatingMethodType.find_by(code: bridge_hash['IRTYPE'].to_s),
      inventory_rating: Uom.convert(bridge_hash['IRLOAD'].to_f, Uom::TONNE, Uom::SHORT_TON).round(NDIGITS),
      bridge_posting_type: BridgePostingType.find_by(code: bridge_hash['POSTING'].to_s),
      remarks: bridge_hash['NOTES']
    }

    # Validate Owner and maintenance responsibility. Could DRY the code some
    unknown = StructureAgentType.find_by(name: 'Unknown')

    custodian = bridge_hash['CUSTODIAN']
    agent = StructureAgentType.find_by(code: custodian)
    if custodian == '-1'
      agent = unknown
    elsif custodian.size == 1
      agent = StructureAgentType.find_by(code: custodian.rjust(2, '0'))
    end
    optional[:maintenance_responsibility] = agent

    owner = bridge_hash['OWNER']
    agent = StructureAgentType.find_by(code: owner)
    if owner == '-1'
      agent = unknown
    elsif owner.size == 1
      agent = StructureAgentType.find_by(code: owner.rjust(2, '0'))
    end
    optional[:owner] = agent
    
    # Bridge vs. Culvert
    case struct_class_code
    when 'BRIDGE'
      optional[:deck_structure_type] = DeckStructureType.find_by(code: bridge_hash['DKSTRUCTYP'])
      optional[:wearing_surface_type] = WearingSurfaceType.find_by(code: bridge_hash['DKSURFTYPE'])
      optional[:membrane_type] = MembraneType.find_by(code: bridge_hash['DKMEMBTYPE'])
      optional[:deck_protection_type] = DeckProtectionType.find_by(code: bridge_hash['DKPROTECT'])
    when 'CULVERT'
    end
    
    # process district, NBI 2E, 2M
    # split into region and maintenance section
    district = bridge_hash['DISTRICT']
    optional[:region] = Region.find_by(code: district[0])
    optional[:maintenance_section] = MaintenanceSection.find_by(code: district[1])

    # process county & city/placecode, NBI 3, 4
    optional[:county] = District.find_by(code: bridge_hash['COUNTY'],
                                         district_type: DistrictType.find_by(name: 'County'))&.name || 'Unknown'
    optional[:city] = District.find_by(code: bridge_hash['PLACECODE'],
                                       district_type: DistrictType.find_by(name: 'Place'))&.name ||
                      District.find_by(code: '-1')

    # See if guid needs to be initialized
    bridgelike.update_attributes(guid: SecureRandom.uuid) unless bridgelike.guid
    
    # Necessary to create bridge if new before processing roadway associations
    bridgelike.save! if is_new
    
    # Process roadway fields
    # Clear out any old roadways
    bridgelike.roadways.destroy_all unless is_new

    on_hash = {}
    if roadway_hash.is_a?(Array)
      # There are multiple roadway sections in the XML, for now find the ON section
      roadway_hash.each do |h|
        if h['ON_UNDER'] == '1'
          on_hash = h
        end
        process_roadway(h, bridgelike)
      end
    elsif roadway_hash
      on_hash = roadway_hash
      process_roadway(on_hash, bridgelike)
    end

    # process milepost, NBI 11A
    optional[:milepoint] = Uom.convert(on_hash['KMPOST'].to_f, Uom::KILOMETER, Uom::MILE).round(NDIGITS)
    
    # Process lat/lon, NBI 16, 17
    # HACK: the bounds checking should be abstracted into a configurable module
    lat = bridge_hash['PRECISE_LAT'].to_f
    lon = bridge_hash['PRECISE_LON'].to_f
    if lat > 36.9 && lat < 41.1 && lon > 102.0 && lon < 109.1
      optional[:latitude] = lat
      optional[:longitude] = lon * -1
    else
      return false, "Location data not valid for #{asset_tag}. lat: #{lat}, lon: #{lon}"
    end

    # NBI 5A
    # NBI 5B
    optional[:route_signing_prefix] = RouteSigningPrefix.find_by(code: on_hash['KIND_HWY'])
    # NBI 5D
    optional[:route_number] = on_hash['ROUTENUM']

    # NBI 32
    optional[:approach_roadway_width] = Uom.convert(on_hash['AROADWIDTH'].to_f, Uom::METER, Uom::FEET).round(NDIGITS)
    
    bridgelike.attributes = optional
    # Save
    bridgelike.save!

    # process inspection data
    # NBI 90, 91
    last_inspection_date = nil
    inspection_frequency = nil
    unless is_new
      # delete all existing inspection data and refresh
      bridgelike.bridge_like_conditions.each(&:destroy)
    end
    
    inspections = {}
    if hash['inspevnt']
      i_hashes = hash['inspevnt'].is_a?(Array) ? hash['inspevnt'] : [hash['inspevnt']]
      i_hashes.each do |i_hash|
        date = Date.parse(i_hash['INSPDATE'])
        if date.is_nil? || date > last_inspection_date
          last_inspection_date = date 
          inspection_frequency = i_hash['BRINSPFREQ']
        end
        # inspection type
        type = InspectionType.find_by(code: i_hash['INSPTYPE'])
        
        inspection = BridgeLikeCondition.new(event_datetime: date, name: bridgelike.asset_tag,
                                             inspection_type: type, notes: i_hash['NOTES'])

        bridgelike.inspections << inspection
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

        if struct_class_code == 'BRIDGE'
          # condition ratings
          {deck_condition_rating_type_id: 'DKRATING',
           superstructure_condition_rating_type_id: 'SUPRATING',
           substructure_condition_rating_type_id: 'SUBRATING'}.each do |attribute, key|
            inspection[attribute] = BridgeConditionRatingType.where(code: i_hash[key]).pluck(:id).first
          end

          inspection.underclearance_appraisal_rating_type_id = BridgeAppraisalRatingType.where(code: i_hash['UNDERCLR']).pluck(:id).first
        else # Culvert
          inspection.culvert_condition_type_id = CulvertConditionType.where(code: i_hash['CULVRATING']).pluck(:id).first
        end      
        
        # appraisal ratings
        {structural_appraisal_rating_type_id: 'STRRATING',
         deck_geometry_appraisal_rating_type_id: 'DECKGEOM',
         waterway_appraisal_rating_type_id: 'WATERADEQ',
         approach_alignment_appraisal_rating_type_id: 'APPRALIGN'}.each do |attribute, key|
          inspection[attribute] = BridgeAppraisalRatingType.where(code: i_hash[key]).pluck(:id).first
        end

        inspection.save!
      end # i_hashes.each
      
      bridgelike.update_attributes(inspection_date: last_inspection_date,
                                   inspection_frequency: inspection_frequency)
    end # if hash['inspevnt']

    elements = {}

    bme_class = ElementClassification.find_by(name: 'BME')
    
    # process element inspection data
    hash['pon_elem_insp']&.each do |e_hash|
      inspection = inspections[e_hash['INSPKEY']].inspection
      elem_number = e_hash['ELEM_KEY'].to_i
      
      elem_parent_def = ElementDefinition.find_by(number: e_hash['ELEM_PARENT_KEY'].to_i)
      if elem_parent_def
        # Find parent element
        parent_elem = elements[elem_parent_def.number]
        units = elem_parent_def.quantity_unit
        
        # Assume defect or BME
        defect_def = DefectDefinition.find_by(number: elem_number)

        if defect_def
          # set quantities
          parent_elem.defects.build(defect_definition: defect_def,
                                    total_quantity: process_quantities(e_hash['ELEM_QUANTITY'], units),
                                    notes: e_hash['ELEM_NOTES'],
                                    condition_state_1_quantity: process_quantities(e_hash['ELEM_QTYSTATE1'], units),
                                    condition_state_2_quantity: process_quantities(e_hash['ELEM_QTYSTATE2'], units),
                                    condition_state_3_quantity: process_quantities(e_hash['ELEM_QTYSTATE3'], units),
                                    condition_state_4_quantity: process_quantities(e_hash['ELEM_QTYSTATE4'], units))


        else # Assume BME
          bme_def = ElementDefinition.find_by(number: elem_number,
                                              element_classification: bme_class)
          if bme_def
            Rails.logger.debug "bd: #{bme_def}"
            bme = parent_elem.children.build(element_definition: bme_def,
                                       quantity: process_quantities(e_hash['ELEM_QUANTITY'], bme_def.quantity_unit),
                                       notes: e_hash['ELEM_NOTES'])
            elements[bme_def.number] = bme
          end
        end
        parent_elem.save!
      else
        elem_def = ElementDefinition.find_by(number: elem_number)

        # If not found, then probably ADE
        if elem_def
          # Process element
          element = inspection.elements.build(element_definition: elem_def,
                                              quantity: process_quantities(e_hash['ELEM_QUANTITY'], elem_def.quantity_unit),
                                              notes: e_hash['ELEM_NOTES'])
          elements[elem_def.number] = element
        end        
      end
      inspection.save!
    end

    # set calculated condition based on existing completed inspections
    bridgelike.set_calculated_condition!

    return true, msg, bridgelike.class.name
  end

  def self.process_roadway(hash, bridgelike)
    # Convert STRAHNET
    strahnet_code =
      case hash['DEFHWY']
      when 1
        2
      when 2
        3
      when 3
        4
      else
        1
      end
    # Validate ON_UNDER
    on_under = hash['ON_UNDER']
    return unless (on_under.size == 1) && (/[12A-Z]/ =~ on_under)
    
    bridgelike.roadways.create!(
      highway_structure: bridgelike,
      on_under_indicator: hash['ON_UNDER'],
      route_signing_prefix: RouteSigningPrefix.find_by(code: hash['KIND_HWY']),
      service_level_type: ServiceLevelType.find_by(code: hash['LEVL_SRVC']),
      route_number: hash['ROUTENUM'],
      min_vertical_clearance: Uom.convert(hash['VCLRINV'].to_f, Uom::METER, Uom::FEET).round(NDIGITS),
      on_base_network: hash['ONBASENET'] == '1',
      lrs_route: hash['LRSINVRT'],
      lrs_subroute: hash['SUBRTNUM'],
      functional_class: FunctionalClass.find_by(code: hash['FUNCCLASS']),
      lanes: hash['LANES'].to_i,
      average_daily_traffic: hash['ADTTOTAL'].to_i,
      average_daily_traffic_year: hash['ADTYEAR'].to_i,
      total_horizontal_clearance: Uom.convert(hash['HCLRINV'].to_f, Uom::METER, Uom::FEET).round(NDIGITS),
      traffic_direction_type: TrafficDirectionType.find_by(code: hash['TRAFFICDIR']),
      on_national_highway_system: hash['NHS_IND'] == '1',
      average_daily_truck_traffic_percent: hash['TRUCKPCT'].to_i,
      on_truck_network: hash['TRUCKNET'] = '1',
      future_average_daily_traffic: hash['ADTFUTURE'].to_i,
      future_average_daily_traffic_year: hash['ADTFUTYEAR'].to_i,
      strahnet_designation_type: StrahnetDesignationType.find_by(code: strahnet_code)
    )
  end
  
  # Convert units if needed and round values
  def self.process_quantities(value, target_units)
    case target_units
    when 'sq feet'
      Uom.convert(value.to_f, Uom::SQUARE_METER, Uom::SQUARE_FOOT).round(NDIGITS)
    when 'feet'
      Uom.convert(value.to_f, Uom::METER, Uom::FEET).round(NDIGITS)
    else
      value.to_f.round(NDIGITS)
    end
  end
  
  #-----------------------------------------------------------------------------
  #
  # Instance Methods
  #
  #-----------------------------------------------------------------------------  

  def dup
    super.tap do |new_asset|
      new_asset.highway_structure = self.highway_structure.dup
    end
  end
  
  def as_json(options={})
    super(options).tap do |json|
      json.merge! acting_as.as_json(options)
      json.merge! "bridge_like_type" => self.asset_subtype.to_s
      json
    end
  end
end