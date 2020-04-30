# -----------------------------------------------
#
# Service to handle NBI export format
#
# -----------------------------------------------

class NbiSubmissionGenerator
  @@state_code = Rails.application.config.state_code
  @@border_state_codes = Rails.application.config.border_state_codes
  @@county_type_id = DistrictType.where(name: 'County').pluck(:id).first
  @@place_type_id = DistrictType.where(name: 'Place').pluck(:id).first
  @@fracture_critical_type = InspectionType.find_by(name: 'Fracture Critical')
  @@underwater_type = InspectionType.find_by(name: 'Underwater')
  @@other_special_type = InspectionType.find_by(name: 'Special')

  def self.nbi_for_structure(structure)
    Rails.logger.debug "Generating NBI for #{structure.asset_tag}"

    structure = structure.very_specific
    # Any conditions should use the most recent finalized inspection
    inspection = structure.inspections.ordered.final.first
    unless inspection
      Rails.logger.warn "No finalized inspection for #{structure.asset_tag}"
      return
    end
    inspection = inspection.specific.becomes(structure.inspection_class)
    result = ""

    # ITEM   ITEM               ITEM
    # NO     NAME               POSITION    LENGTH/TYPE
    # 1      State Code         1 - 3       3/N
    result << @@state_code
    # 8      Structure Number   4 - 18      15/AN
    result << structure.structure_number.ljust(15)

    # 5      Inventory Route   19 - 27      9/AN
    roadway = structure.roadways.on.first || structure.roadways.under.first
    if roadway
    # 5A     Record Type          19        1/AN
      result << roadway.on_under_indicator
    # 5B     Route Signing Prefix 20        1/N
      result << roadway.route_signing_prefix.code
    # 5C     Des. Level Service   21        1/N
      result << roadway.service_level_type.code
    # 5D     Route Number      22 - 26      5/AN
      result << roadway.route_number.rjust(5, '0')
    # 5E     Directional Suffix   27        1/N
      result << '0'
    else
      result << '         '
    end

    # 2    Highway Agency District 28 - 29   2/AN
    # CDOT specific
    # 2E   Engineering Region         28     1/AN
    # 2M   Maintenance Section        29     1/AN
    result << structure.region.code
    result << structure.maintenance_section.code

    # 3    County (Parish) Code    30 - 32   3/N
    result << District.where(district_type_id: @@county_type_id, name: structure.county).pluck(:code).first
    # 4    Place Code              33 - 37   5/N
    result <<  District.where(district_type_id: @@place_type_id, name: structure.city).pluck(:code).first
    # 6    Features Intersected    38 - 62  25/AN
    # 6A   Features Intersected    38 - 61  24/AN
    # 6B   Critical Facility          62     1/AN
    result << structure.features_intersected.ljust(25)
    # 7    Facility Carried        63 - 80  18/AN
    result << structure.facility_carried.ljust(18)
    # 9    Location                81 - 105 25/AN
    result << structure.location_description.ljust(25)

    #  Inventory Route
    # 10   Min Vert Clearance      106 - 109 4/N
    # Convert from feet to XX[.]XX meters
    mvc_ft = roadway.min_vertical_clearance
    mvc_m = mvc_ft ? Uom.convert(mvc_ft, Uom::FEET, Uom::METER) : nil
    result << ((mvc_m && mvc_m >= 0) ? (mvc_m * 100).round.to_s[0..3].rjust(4, '0') : '9999')

    # 11   Kilometerpoint          110 - 116 7/N
    # Convert from miles to XXXX[.]XXX kilometers
    result << (Uom.convert(structure.milepoint, Uom::MILE, Uom::KILOMETER) * 1000).round.to_s[0..6].rjust(7, '0')

    #  Inventory Route
    # 12   Base Highway Network       117    1/N
    result << (roadway.on_base_network ? '1' : '0')
    # 13   Subroute Number        118 - 129 12/AN
    # 13A  LRS Inventory Route    118 - 127 10/AN
    result << (roadway.on_base_network ? roadway.lrs_route.to_s : '').rjust(10, '0')
    # 13B  Subroute Number        128 - 129  2/N
    result << (roadway.on_base_network ? roadway.lrs_subroute.to_s : '').rjust(2, '0')

    # XX degrees XX minutes XX[.]XX seconds
    # 16   Latitude               130 - 137  8/N
    result << encode_decimal_to_dms(structure.geometry.y).rjust(8, '0')
    # XXX degrees XX minutes XX[.]XX seconds
    # 17   Longitude              138 - 146  9/N
    result << encode_decimal_to_dms(structure.geometry.x).rjust(9, '0')

    # 19  Bypass/Detour Length   147 - 149  3/N
    result << [199, Uom.convert(roadway.detour_length, Uom::MILE, Uom::KILOMETER)].min.round.to_s.rjust(3, '0')

    # 20   Toll                      150     1/N
    result << (structure.bridge_toll_type&.code || '3')

    # 21   Maint. Responsibility  151 - 152  2/N
    result << structure.maintenance_responsibility.code
    # 22   Owner                  153 - 154  2/N
    result << structure.owner.code
    # 26   Functional Class       155 - 156  2/N
    result << (roadway.functional_class&.code || 'XX')
    # 27   Year Built             157 - 160  4/N
    result << (structure.manufacture_year || '1900').to_s
    # 28   Lanes On/Under         161 - 164  4/N
    # 28A  Lanes On Structure     161 - 162  2/N
    result << structure.lanes_on.to_s.rjust(2, '0')
    # 28B  Lanes Under Structure  163 - 164  2/N
    result << structure.lanes_under.to_s.rjust(2, '0')
    # 29   Average Daily Traffic  165 - 170  6/N
    result << roadway.average_daily_traffic.to_s.rjust(6, '0')
    # 30   Year ADT               171 - 174  4/N
    result << roadway.average_daily_traffic_year.to_s
    # 31   Design Load               175     1/N
    result << (structure.design_load_type&.code || '0')
    # 32   Approach Roadway Width 176 - 179  4/N
    result << convert_to_field(structure.approach_roadway_width, 4, 1)

    # 33  Bridge Median             180     1/N
    result << structure.median_type.code
    # 34  Skew                   181 - 182  2/N
    result << structure.skew.to_s.rjust(2, '0')
    # 35  Structure Flared          183     1/N
    result << (structure.is_flared ? '1' : '0')

    # ITEM                        ITEM      ITEM
    # NO   ITEM NAME              POSITION  LENGTH/TYPE
    # 36   Safety Features        184 - 187  4/AN
    # 36A  Bridge Railings           184     1/AN
    result << (inspection.railings_safety_type&.code || 'N')
    # 36B  Transitions               185     1/AN
    result << (inspection.transitions_safety_type&.code || 'N')
    # 36C  Approach Guardrail        186     1/AN
    result << (inspection.approach_rail_safety_type&.code || 'N')
    # 36D  Approach Guardrail Ends   187     1/AN
    result << (inspection.approach_rail_end_safety_type&.code || 'N')

    # 37   Historical significance   188     1/N
    result << structure.historical_significance_type.code
    # *38  Navigation Control        189     1/AN
    result << '0'
    # *39  Nav Vert Clearance    190 - 193   4/N
    result << '0000'
    # *40  Nav Horiz Clearance   194 - 198   5/N
    result << '00000'

    # 41   Open/Posted/Closed       199      1/AN
    result << inspection.operational_status_type.code

    # 42   Type Of Service       200 - 201   2/N
    # 42A  Type of Service On       200      1/N
    result << structure.service_on_type.code
    # 42B  Type of Service Under    201      1/N
    result << structure.service_under_type.code
    # 43   Structure Type, Main  202 - 204   3/N
    # 43A  Kind of Material/Design  202      1/N
    result << structure.main_span_material_type.code
    # 43B  Design/Construction   203 - 204   2/N
    result << structure.main_span_design_construction_type.code
    # 44   Type, Approach Spans  205 - 207   3/N
    if structure.num_spans_approach > 0
      # 44A  Kind of Material/Design  205      1/N
      result << structure.approach_spans_material_type.code
      # 44B  Type of Design/Const. 206 - 207   2/N
      result << structure.approach_spans_design_construction_type.code
    else
      result << '000'
    end
    # 45   Num Spans Main Unit   208 - 210   3/N
    result << structure.num_spans_main.to_s.rjust(3, '0')
    # 46   Num Approach Spans    211 - 214   4/N
    result << structure.num_spans_approach.to_s.rjust(4, '0')

    # 47   Total Horz Clearance  215 - 217   3/N
    result << convert_to_field(roadway.total_horizontal_clearance, 3, 1)
    # 48   Length Maximum Span   218 - 222   5/N
    result << convert_to_field(structure.max_span_length, 5, 1)
    # 49   Structure Length      223 - 228   6/N
    result << convert_to_field(structure.length, 6, 1)
    # 50   Curb/Sidewalk Widths  229 - 234   6/N
    # 50A  Left Width            229 - 231   3/N
    result << convert_to_field(structure.left_curb_sidewalk_width, 3, 1)
    # 50B  Right Width           232 - 234   3/N
    result << convert_to_field(structure.right_curb_sidewalk_width, 3, 1)
    # 51   Roadway Width         235 - 238   4/N
    result << convert_to_field(structure.roadway_width, 4, 1)
    # 52   Deck Width            239 - 242   4/N
    result << convert_to_field(structure.deck_width, 4, 1)

    # 53   Min Vert Clear Over Roadway 243 - 246 4/N
    result << convert_to_field(structure.min_vertical_clearance_above, 4, 2)
    # 54   Min Vert Underclearance     247 - 251 5/AN
    # 54A  Reference Feature              247      1/AN
    code = structure.vertical_reference_feature_below.code
    result << code
    # 54B  Min Vert Underclearance     248 - 251 4/N
    result << (code == 'N' ? '0000' : convert_to_field(structure.min_vertical_clearance_below, 4, 2))
    # 55   Min Lat Underclear On Right 252 - 255 4/AN
    # 55A  Reference Feature              252    1/AN
    code = structure.lateral_reference_feature_below.code
    result << code
    # 55B  Min Lateral Underclearance  253 - 255 3/N
    result << (code == 'N' ? '000' : convert_to_field(structure.min_vertical_clearance_below, 3, 1))
    # 56   Min Lat Underclear On Left  256 - 258 3/N
    value = structure.min_lateral_clearance_below_left
    result << (value <= 0.0 ? '000' : convert_to_field(value, 3, 1))

    # Conditions

    # 58   Deck                           259    1/AN
    # 59   Superstructure                 260    1/AN
    # 60   Substructure                   261    1/AN
    # 61   Channel/Channel Protection     262    1/AN
    # 62   Culverts                       263    1/AN
    channel_code = (inspection.channel_condition_type&.code || 'N')
    if inspection.respond_to? :culvert_condition_type
      result << 'N' << 'N' << 'N'
      result << channel_code
      result << inspection.culvert_condition_type.code
    else
      result << (inspection.deck_condition_rating_type&.code || 'N')
      result << (inspection.superstructure_condition_rating_type&.code || 'N')
      result << (inspection.substructure_condition_rating_type&.code || 'N')
      result << channel_code
      result << 'N'
    end

    # ITEM                            ITEM      ITEM
    # NO   ITEM NAME                  POSITION  LENGTH/TYPE
    # 63   Operating Rating Method       264      1/N
    result << (structure.operating_rating_method_type&.code || '5')
    # 64   Operating Rating           265 - 267   3/N
    result << convert_to_field(structure.operating_rating, 3, 1)
    # 65   Inventory Rating Method       268      1/N
    result << (structure.inventory_rating_method_type&.code || '5')
    # 66   Inventory Rating           269 - 271   3/N
    result << convert_to_field(structure.inventory_rating, 3, 1)

    # 67   Structural Evaluation         272      1/AN
    result << inspection.structural_appraisal_rating_type.code
    # 68   Deck Geometry                 273      1/AN
    result << inspection.deck_geometry_appraisal_rating_type.code
    # 69   Underclear, Vert. & Horiz     274      1/AN
    rating = inspection.try(:underclearance_appraisal_rating_type)
    result << (rating ? rating.code : 'N')

    # 70   Bridge Posting                275      1/N
    result << (structure.bridge_posting_type&.code || '5')

    # 71   Waterway Adequacy             276      1/AN
    result << (inspection.waterway_appraisal_rating_type&.code || 'N')
    # 72   Approach Roadway Alignment    277      1/AN
    result << (inspection.approach_alignment_appraisal_rating_type&.code || 'N')

    # *75  Type of Work               278 - 280   3/N
    # *75A Type of Work Proposed      278 - 279   2/N
    # *75B Work Done By                  280      1/AN
    result << '   '
    # *76  Length Of Improvement      281 - 286   6/N
    result << '      '

    # 90    Inspection Date           287 - 290   4/N
    result << inspection.event_datetime.strftime('%m%y')
    # 91    Inspection Frequency      291 - 292   2/N
    result << inspection.inspection_frequency.to_s.rjust(2, '0')

    # Other inspection data
    fc_settings = structure.inspection_type_settings.find_by(inspection_type: @@fracture_critical_type, is_required: true)
    uw_settings = structure.inspection_type_settings.find_by(inspection_type: @@underwater_type, is_required: true)
    # Other special needs to be recurring, not one off
    os_settings = structure.inspection_type_settings.find_by(inspection_type: @@other_special_type, is_required: true)

    # 92    Critical Feature Insp     293 - 301   9/AN
    # 92A   Fracture Critical Details 293 - 295   3/AN
    result << inspection_required(fc_settings)
    # 92B   Underwater Inspection     296 - 298   3/AN
    result << inspection_required(uw_settings)
    # 92C   Other Special Inspection  299 - 301   3/AN
    result << inspection_required(os_settings)

    # 93    Crit Feature Insp Dates   302 - 313  12/AN
    # 93A   Frac Crit Details Date    302 - 305   4/AN
    result << inspection_details(fc_settings, structure)
    # 93B   Underwater Insp. Date     306 - 309   4/AN
    result << inspection_details(uw_settings, structure)
    # 93C   Other Special Insp Date   310 - 313   4/AN
    result << inspection_details(os_settings, structure)

    # *94   Bridge Improvement Cost   314 - 319   6/N
    # *95   Roadway Improvement Cost  320 - 325   6/N
    # *96   Total Project Cost        326 - 331   6/N
    # *97   Year Of Imp Cost Estimate 332 - 335   4/N
    result << ' '*6 << ' '*6 << ' '*6 << ' '*4

    # 98    Border Bridge             336 - 340   5/AN
    if structure.border_bridge_state.present?
      # 98A Neighboring State Code    336 - 338   3/AN
      result << @@border_state_codes[structure.border_bridge_state]
      # 98B Percent Responsibility    339 - 340   2/N
      percent = structure.border_bridge_pcnt_responsibility
      result << (percent == 100 ? '99' : percent.to_s.rjust(2, '0'))
      # 99 Border Bridge Structure #  341 - 355  15/AN
      result << structure.border_bridge_structure_number.ljust(15)
    else
      result << ' '*20
    end

    # 100  STRAHNET Highway Designation  356      1/N
    result << (roadway.strahnet_designation_type&.code || '0')

    # 101 Parallel Designation          357      1/AN
    result << (structure.parallel_structure || 'N')

    # 102 Direction Of Traffic           358      1/N
    result << (roadway.traffic_direction_type&.code || '0')

    # 103 Temporary Designation          359      1/AN
    result << (structure.is_temporary ? 'T' : ' ')

    # 104 Highway System Inventory Route 360      1/N
    result << (roadway.on_national_highway_system ? '1' : '0')
    # 105 Federal Lands Highways         361      1/N
    result << (roadway.federal_lands_highway_type&.code || '0')

    # 106 Year Reconstructed          362 - 365   4/N
    result << (structure.reconstructed_year&.to_s || '0000')

    # Only applies to Bridges not Culverts
    if structure.is_a? Bridge
      # 107 Deck Structure Type            366      1/AN
      result << structure.deck_structure_type.code
      # 108 Wearing Surface/Prot. Sys.  367 - 369   3/AN
      # 108A Type of Wearing Surface       367      1/AN
      result << structure.wearing_surface_type.code
      # 108B Type of Membrane              368      1/AN
      result << structure.membrane_type.code
      # 108C Deck Protection               369      1/AN
      result << structure.deck_protection_type.code
    else
      result << 'NNNN'
    end

    # ITEM                             ITEM       ITEM
    # NO   ITEM NAME                   POSITION   LENGTH/TYPE
    # 109  AVERAGE DAILY TRUCK TRAFFIC 370 - 371   2/N
    result << roadway.average_daily_truck_traffic_percent.to_s.rjust(2, '0')
    # 110  DESIGNATED NATIONAL NETWORK    372      1/N
    result << (roadway.on_truck_network ? '1' : '0')

    # *111  PIER/ABUTMENT PROTECTION       373      1/N
    # Not use by CDOT
    result << '1'
    # 112  NBIS BRIDGE LENGTH             374      1/AN
    result << (structure.is_nbis_length ? 'Y' : 'N')

    # 113  SCOUR CRITICAL BRIDGES         375      1/AN
    result << (inspection.scour_critical_bridge_type&.code || 'N')

    # 114  FUTURE AVERAGE DAILY TRAF   376 - 381   6/N
    result << roadway.future_average_daily_traffic.to_s.rjust(6, '0')
    # 115  YEAR FUTURE AVG DAILY TRAF  382 - 385   4/N
    result << roadway.future_average_daily_traffic_year.to_s
    # *116  MINIMUM NAV VERTICAL        386 - 389   4/N
    #       CLEARANCE VERTICAL LIFT BRIDGE
    # Not used by CDOT
    result << ' '*4
    # --- Washington Headquarters Use 390 - 433
    result << ' '*44

    # Check expected string length
    Rails.logger.warn "result length is #{result.length}, should be 433" if result.length != 433
    result
  end

  def self.nbi_for_list(inspections)
    BridgeLike.includes(highway_structure: {transam_asset: {asset_subtype: :asset_type}})
      .includes(highway_structure: [:region, :maintenance_section, :maintenance_responsibility, :owner,
                                    :historical_significance_type])
      .includes(:bridge_toll_type, :design_load_type, :service_on_type, :service_under_type,
                :main_span_material_type, :main_span_design_construction_type, :approach_spans_material_type,
                :approach_spans_design_construction_type, :vertical_reference_feature_below, :lateral_reference_feature_below,
                :operating_rating_method_type, :inventory_rating_method_type, :bridge_posting_type)
      .where(highway_structures: {id: inspections.pluck(:transam_asset_id).uniq})
      .collect{ |hs| nbi_for_structure(hs) }.compact.join("\n")
  end

  def self.encode_decimal_to_dms(degrees)
    degrees = degrees.abs
    m = 60 * (degrees - degrees.to_i)
    s = 60 * (m - m.to_i)

    "#{degrees.to_i.to_s}#{m.to_i.to_s.rjust(2, '0')}#{(s * 100).to_i.to_s[0..3].rjust(4, '0')}"
  end

  def self.convert_to_field(value, width, decimal, default='9', from=Uom::FEET, to=Uom::METER)
    default * width unless value
    (Uom.convert(value, from, to) * (10**decimal)).round.to_s[0..(width - 1)].rjust(width, '0')
  end

  def self.inspection_required(settings)
    settings ? "Y#{settings.frequency_months.to_s.rjust(2, '0')}" : 'N  '
  end

  def self.inspection_details(settings, structure)
    output = '    '
    if settings
      last_inspection = structure.inspections.ordered.final.find_by(inspection_type: settings.inspection_type)
      output = last_inspection.event_datetime.strftime('%m%y') if last_inspection&.event_datetime
    end
    output
  end
end
