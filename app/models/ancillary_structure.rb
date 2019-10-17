class AncillaryStructure < BridgeLike

  has_many :ancillary_conditions, through: :inspections, source: :inspectionible, source_type: 'StructureCondition', class_name: 'AncillaryCondition'

  #-----------------------------------------------------------------------------
  # Instance Methods
  #-----------------------------------------------------------------------------  
  def latest_ancillary_condition
    ancillary_conditions.ordered.first
  end

  def set_calculated_condition!
    self.calculated_condition = latest_ancillary_condition&.calculated_condition || 'unknown'
    self.save
  end

  #-----------------------------------------------------------------------------
  # Class Methods
  #-----------------------------------------------------------------------------

  def self.process_roadway(hash, structure)
  end

  def self.process_inspection(hash, struct_class_code, date)
    inspection_frequency = hash['BRINSPFREQ']
    type = InspectionType.find_by(code: hash['INSPTYPE'])

    inspection = AncillaryCondition.new(event_datetime: date, calculated_inspection_due_date: date,
                                        inspection_frequency: inspection_frequency, inspection_type: type,
                                        notes: hash['NOTES'], state: 'final')
    inspection.save!
    inspection
  end

  def self.process_bridge_record(hash, struct_class_code, struct_type_code,
                                 highway_authority, inspection_program, inspection_trip)
    asset_tag = hash['BRKEY']
    
    # Structure Class, NBI 24 is 
    structure = nil
    case struct_class_code
    when 'MASTARM SIGNAL'
      structure = HighwaySignal.find_or_initialize_by(asset_tag: asset_tag)
    else
      # TODO: Try to determin based on struct_class_code
      msg = "Skipping processing of Structure Class: #{struct_class_code}"
      return false, msg
    end
    
    if structure.new_record?
      msg = "Created #{inspection_program} #{struct_class_code} #{asset_tag}"
      # Set asset required fields
      # determine correct asset_subtype, NBI 43D
      asset_subtype = AssetSubtype.find_by(asset_type: AssetType.find_by(class_name: structure.class.name))
      required = {
        asset_subtype: asset_subtype,
        organization: highway_authority,
        purchase_cost: 0,
        in_service_date: Date.today,
        purchase_date: Date.today,
        purchased_new: true
      }
      structure.attributes = required
    else
      msg = "Updated #{inspection_program} #{struct_class_code} #{asset_tag}"
    end

    unless inspection_trip.blank?
      # break down 
      inspection_trip_parts = inspection_trip.split(" ")
      # TODO: get format from CDOT and parse
      inspection_fiscal_year = nil
      inspection_month = nil
      inspection_quarter = nil
      inspection_trip_key = nil
      inspection_second_quarter = nil
      inspection_second_trip_key = nil
      inspection_zone = nil
    end

    optional = {
      # TransamAsset, NBI 1, 8, 27
      state: structure.organization.state,
      structure_number: hash['STRUCT_NUM'],
      manufacture_year: hash['YEARBUILT'],
      # HighwayStructure, NBI 6A, 9, 21, 22, 23, 37, 43C, 103
      features_intersected: hash['FEATINT'],
      location_description: hash['LOCATION'],
      description: hash['LOCATION'],
      structure_status_type: StructureStatusType.find_by(code: hash['BRIDGE_STATUS']),
      historical_significance_type: HistoricalSignificanceType.find_by(code: hash['HISTSIGN']),
      highway_structure_type: HighwayStructureType.find_by(code: struct_type_code),
      is_temporary: (hash['TEMPSTRUC'] == 'T'),
      # Structure, NBI 42B, 45, 49, 54B
      service_under_type: ServiceUnderType.find_by(code: hash['SERVTYPUND']),
      num_spans_main: hash['MAINSPANS'].to_i, # interpreted by each subclass
      length: Uom.convert(hash['LENGTH'].to_f, Uom::METER, Uom::FEET).round(NDIGITS),

      min_vertical_clearance_below: Uom.convert(hash['VCLRUNDER'].to_f, Uom::METER, Uom::FEET).round(NDIGITS),

      remarks: hash['NOTES'],
      inspection_program: inspection_program,
      inspection_trip: inspection_trip,
      inspection_zone: inspection_zone,
      inspection_fiscal_year: inspection_fiscal_year,
      inspection_month: inspection_month,
      inspection_quarter: inspection_quarter,
      inspection_trip_key: inspection_trip_key&.to_i,
      inspection_second_quarter: inspection_second_quarter,
      inspection_second_trip_key: inspection_second_trip_key&.to_i
    }

    # Validate Owner and maintenance responsibility. 
    unknown = StructureAgentType.find_by(name: 'Unknown')

    optional[:maintenance_responsibility] = determine_agent(unknown, hash['CUSTODIAN'])
    optional[:owner] = determine_agent(unknown, hash['OWNER'])
    
    # Ancillary specific fields, probably will be separate method eventually
    
    # process district, NBI 2E, 2M
    # split into region and maintenance section
    district = hash['DISTRICT']
    optional[:region] = Region.find_by(code: district[0])
    optional[:maintenance_section] = MaintenanceSection.find_by(code: district[1])

    # process county & city/placecode, NBI 3, 4
    optional[:county] = District.find_by(code: hash['COUNTY'],
                                         district_type: DistrictType.find_by(name: 'County'))&.name || 'Unknown'
    optional[:city] = District.find_by(code: hash['PLACECODE'],
                                       district_type: DistrictType.find_by(name: 'Place'))&.name ||
                      District.find_by(code: '-1')

    # Process lat/lon, NBI 16, 17
    lat = hash['PRECISE_LAT'].to_f
    lon = -1 * hash['PRECISE_LON'].to_f
    c = SystemConfig.instance
    if lat > c.min_lat && lat < c.max_lat && lon > c.min_lon && lon < c.max_lon
      optional[:latitude] = lat
      optional[:longitude] = lon
    else
      return false, "Location data not valid for #{asset_tag}. lat: #{lat}, lon: #{lon}"
    end

    # See if guid needs to be initialized
    structure.guid = SecureRandom.uuid unless structure.guid
    
    structure.attributes = optional

    return structure, msg
  end
end
