class AncillaryStructure < BridgeLike

  has_many :ancillary_conditions, through: :inspections, source: :inspectionible, source_type: 'BridgeLikeCondition', class_name: 'AncillaryCondition'

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
    puts msg
    return structure, msg
  end
end
