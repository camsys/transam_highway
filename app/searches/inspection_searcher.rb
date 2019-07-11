#------------------------------------------------------------------------------
#
# Inspection Searcher
#
# Concrete implementation that returns inspections
#
#------------------------------------------------------------------------------
class InspectionSearcher < BaseSearcher
  # search proxy
  attr_accessor :search_proxy
  attr_accessor :organization_ids

  # Return the name of the form to display
  def form_view
    'inspection_search_form'
  end
  # Return the name of the results table to display
  def results_view
    'inspection_search_results_table'
  end

  def cache_variable_name
    InspectionsController::INDEX_KEY_LIST_VAR
  end
               
  def initialize(attributes = {})
    super(attributes)
  end    
  
  private

  def inspection_klass
    join_sql = <<-SQL 
      LEFT OUTER JOIN regions 
        ON highway_structures.region_id = regions.id
      LEFT OUTER JOIN inspection_programs 
        ON highway_structures.inspection_program_id = inspection_programs.id
      LEFT OUTER JOIN organizations as assigned_organizations
        ON inspections.assigned_organization_id = assigned_organizations.id
      LEFT OUTER JOIN structure_agent_types as owners 
        ON highway_structures.owner_id = owners.id
      LEFT OUTER JOIN structure_status_types 
        ON highway_structures.structure_status_type_id = structure_status_types.id
      LEFT OUTER JOIN bridge_likes 
        ON highway_structures.highway_structurible_id = bridge_likes.id AND highway_structures.highway_structurible_type = 'BridgeLike'
    SQL

    @inspection_klass ||= Inspection.joins(highway_structure: {transam_asset: {asset_subtype: :asset_type}})
                                    .left_outer_joins(:organization_type)
                                    .joins(join_sql)
  end

  # Add any new conditions here. The property name must end with _conditions
  def organization_conditions
    if organization_ids.blank? 
      organization_ids = user&.viewable_organization_ids
    end
    if organization_ids.any?
      if user.organization.organization_type.class_name == 'HighwayAuthority'
        inspection_klass.where("transam_assets.organization_id": organization_ids)
      elsif user.organization.organization_type.class_name == 'HighwayConsultant'
        inspection_klass.where("transam_assets.organization_id": organization_ids).where("inspections.assigned_organization_id": user&.organization_ids)
      end
    end

  end

  #------------------------------------------------------------------------------
  # search proxy conditions
  #------------------------------------------------------------------------------

  def asset_subtype_conditions
    clean_subtypes = remove_blanks(search_proxy&.asset_subtype)
    inspection_klass.where("asset_subtypes.id": clean_subtypes) unless clean_subtypes.blank?
  end

  def asset_tag_conditions
    inspection_klass.where(Arel.sql("transam_assets.asset_tag LIKE '%#{search_proxy&.asset_tag}%'")) unless search_proxy&.asset_tag.blank?
  end

  def asset_tag_conditions
    inspection_klass.where(Arel.sql("transam_assets.asset_tag LIKE '%#{search_proxy&.asset_tag}%'")) unless search_proxy&.asset_tag.blank?
  end

  def region_code_conditions
    clean_region_codes = remove_blanks(search_proxy&.region_code)
    inspection_klass.where("regions.code": clean_region_codes) unless clean_region_codes.empty?
  end

  def structure_status_type_code_conditions
    clean_structure_status_type_codes = remove_blanks(search_proxy&.structure_status_type_code)
    inspection_klass.where("structure_status_types.code": clean_structure_status_type_codes) unless clean_structure_status_type_codes.empty?
  end

  def owner_id_conditions
    clean_owner_ids = remove_blanks(search_proxy&.owner_id)
    inspection_klass.where("highway_structures.owner_id": clean_owner_ids) unless clean_owner_ids.empty?
  end

  def calculated_condition_conditions
    clean_condition_codes = remove_blanks(search_proxy&.calculated_condition)
    inspection_klass.where("highway_structures.calculated_condition": clean_condition_codes) unless clean_condition_codes.empty?
  end

  def service_on_type_id_conditions
    clean_service_on_type_ids = remove_blanks(search_proxy&.service_on_type_id)
    inspection_klass.where("bridge_likes.service_on_type_id": clean_service_on_type_ids) unless clean_service_on_type_ids.empty?
  end

  def service_under_type_id_conditions
    clean_service_under_type_ids = remove_blanks(search_proxy&.service_under_type_id)
    inspection_klass.where("bridge_likes.service_under_type_id": clean_service_under_type_ids) unless clean_service_under_type_ids.empty?
  end

  def on_national_highway_system_conditions
    unless search_proxy&.on_national_highway_system.blank?
      asset_ids = Roadway.where(on_national_highway_system: search_proxy&.on_national_highway_system == 'yes').pluck(:transam_asset_id).uniq
      inspection_klass.where("transam_asset_id": asset_ids) 
    end
  end

  def county_conditions
    inspection_klass.where("highway_structures.county": search_proxy&.structure_county) unless search_proxy&.structure_county.blank?
  end

  def city_conditions
    inspection_klass.where("highway_structures.city": search_proxy&.structure_city) unless search_proxy&.structure_city.blank?
  end

  def inspection_program_id_conditions
    inspection_klass.where("highway_structures.inspection_program_id": parse_nil_search_value(search_proxy&.inspection_program_id)) unless search_proxy&.inspection_program_id.blank?
  end

  def organization_type_id_conditions
    inspection_klass.where("inspections.organization_type_id": parse_nil_search_value(search_proxy&.organization_type_id)) unless search_proxy&.organization_type_id.blank?
  end

  def assigned_organization_id_conditions
    inspection_klass.where("inspections.assigned_organization_id": parse_nil_search_value(search_proxy&.assigned_organization_id)) unless search_proxy&.assigned_organization_id.blank?
  end

  def state_conditions
    clean_states = remove_blanks(search_proxy&.state)
    inspection_klass.where("inspections.state": clean_states) unless clean_states.empty?
  end

  def inspector_id_conditions
    unless search_proxy&.inspector_id.blank?
      insp_ids = Inspection.joins(:inspectors).where("inspections_users.user_id": parse_nil_search_value(search_proxy&.inspector_id)).distinct.pluck("inspections.id")
      inspection_klass.where("inspections.id": insp_ids) 
    end
  end

  def inspection_fiscal_year_conditions
    inspection_klass.where("highway_structures.inspection_fiscal_year": search_proxy&.inspection_fiscal_year) unless search_proxy&.inspection_fiscal_year.blank?
  end

  def inspection_month_conditions
    inspection_klass.where("highway_structures.inspection_month": search_proxy&.inspection_month) unless search_proxy&.inspection_month.blank?
  end

  def inspection_quarter_conditions
    if !search_proxy&.inspection_quarter.blank? && !search_proxy&.inspection_trip_key.blank?
      # if both params are provided, then need to query the combo
      inspection_klass.where(
        "highway_structures.inspection_quarter": search_proxy&.inspection_quarter, 
        "highway_structures.inspection_trip_key": search_proxy&.inspection_trip_key
        ).or(inspection_klass.where(
          "highway_structures.inspection_second_quarter": search_proxy&.inspection_quarter, 
          "highway_structures.inspection_second_trip_key": search_proxy&.inspection_trip_key
          ))
    elsif !search_proxy&.inspection_quarter.blank?
      inspection_klass.where(
        "highway_structures.inspection_quarter": search_proxy&.inspection_quarter
        ).or(inspection_klass.where(
          "highway_structures.inspection_second_quarter": search_proxy&.inspection_quarter
          ))
    elsif !search_proxy&.inspection_trip_key.blank?
      inspection_klass.where(
        "highway_structures.inspection_trip_key": search_proxy&.inspection_trip_key
        ).or(inspection_klass.where(
          "highway_structures.inspection_second_trip_key": search_proxy&.inspection_trip_key
          ))
    end
  end

  def inspection_frequency_conditions
    inspection_klass.where("inspections.inspection_frequency": search_proxy&.inspection_frequency) unless search_proxy&.inspection_frequency.blank?
  end

  def min_calculated_inspection_due_date_conditions
    inspection_klass.where(Inspection.arel_table[:calculated_inspection_due_date].gteq(parse_date(search_proxy&.min_calculated_inspection_due_date))) unless search_proxy&.min_calculated_inspection_due_date.blank?
  end

  def max_calculated_inspection_due_date_conditions
    inspection_klass.where(Inspection.arel_table[:calculated_inspection_due_date].lteq(parse_date(search_proxy&.max_calculated_inspection_due_date))) unless search_proxy&.max_calculated_inspection_due_date.blank?
  end

  def min_inspection_date_conditions
    inspection_klass.where(Inspection.arel_table[:event_datetime].gteq(parse_date(search_proxy&.min_inspection_date))) unless search_proxy&.min_inspection_date.blank?
  end

  def max_inspection_date_conditions
    inspection_klass.where(Inspection.arel_table[:event_datetime].lteq(parse_date(search_proxy&.max_inspection_date))) unless search_proxy&.max_inspection_date.blank?
  end

  #TODO:inspection_zone, etc

  def parse_date(mm_dd_yyyy_str)
    Date.strptime(mm_dd_yyyy_str, "%m/%d/%Y")
  end

  def parse_nil_search_value(val)
    # Use -1 to represent nil search
    if val&.to_s == '-1'
      nil 
    else
      val
    end 
  end

end
