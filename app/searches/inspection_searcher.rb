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
      LEFT OUTER JOIN roadways 
        ON highway_structures.id = roadways.transam_asset_id
    SQL

    @inspection_klass ||= Inspection.joins(highway_structure: {transam_asset: {asset_subtype: :asset_type}})
                                    .left_outer_joins(:organization_type, :inspectors)
                                    .joins(join_sql)
  end

  # Add any new conditions here. The property name must end with _conditions
  def organization_conditions
    if organization_ids.blank? 
      organization_ids = user&.organization_ids
    end

    inspection_klass.where("transam_assets.organization_id": organization_ids) if organization_ids.any?
  end

  #------------------------------------------------------------------------------
  # search proxy conditions
  #------------------------------------------------------------------------------
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
    inspection_klass.where("roadways.on_national_highway_system": search_proxy&.on_national_highway_system == 'yes') unless search_proxy&.on_national_highway_system.blank?
  end

  def county_conditions
    inspection_klass.where("highway_structures.county": search_proxy&.structure_county) unless search_proxy&.structure_county.blank?
  end

  def city_conditions
    inspection_klass.where("highway_structures.city": search_proxy&.structure_city) unless search_proxy&.structure_city.blank?
  end

  def inspection_program_id_conditions
    inspection_klass.where("highway_structures.inspection_program_id": search_proxy&.inspection_program_id) unless search_proxy&.inspection_program_id.blank?
  end

  def organization_type_id_conditions
    inspection_klass.where("inspections.organization_type_id": search_proxy&.organization_type_id) unless search_proxy&.organization_type_id.blank?
  end

  def assigned_organization_id_conditions
    inspection_klass.where("inspections.assigned_organization_id": search_proxy&.assigned_organization_id) unless search_proxy&.assigned_organization_id.blank?
  end

  def state_conditions
    clean_states = remove_blanks(search_proxy&.state)
    inspection_klass.where("inspections.state": clean_states) unless clean_states.empty?
  end

  def inspector_id_conditions
    inspection_klass.where("inspections_users.user_id": search_proxy&.inspector_id) unless search_proxy&.inspector_id.blank?
  end

  def qa_inspector_id_conditions
    inspection_klass.where("inspections.qa_inspector_id": search_proxy&.qa_inspector_id) unless search_proxy&.qa_inspector_id.blank?
  end

  def qc_inspector_id_conditions
    inspection_klass.where("inspections.qc_inspector_id": search_proxy&.qc_inspector_id) unless search_proxy&.qc_inspector_id.blank?
  end

  def inspection_trip_conditions
    inspection_klass.where("highway_structures.inspection_trip": search_proxy&.inspection_trip) unless search_proxy&.inspection_trip.blank?
  end

  def inspection_frequency_conditions
    inspection_klass.where("highway_structures.inspection_frequency": search_proxy&.inspection_frequency) unless search_proxy&.inspection_frequency.blank?
  end

  def min_next_inspection_date_conditions
    inspection_klass.where(HighwayStructure.arel_table[:next_inspection_date].gteq(parse_date(search_proxy&.min_next_inspection_date))) unless search_proxy&.min_next_inspection_date.blank?
  end

  def max_next_inspection_date_conditions
    inspection_klass.where(HighwayStructure.arel_table[:next_inspection_date].lteq(parse_date(search_proxy&.max_next_inspection_date))) unless search_proxy&.max_next_inspection_date.blank?
  end

  def min_inspection_date_conditions
    inspection_klass.where(Inspection.arel_table[:event_datetime].gteq(parse_date(search_proxy&.min_inspection_date))) unless search_proxy&.min_inspection_date.blank?
  end

  def max_inspection_date_conditions
    inspection_klass.where(Inspection.arel_table[:event_datetime].lteq(parse_date(search_proxy&.max_inspection_date))) unless search_proxy&.max_inspection_date.blank?
  end

  #TODO: inspector_id, inspection_zone, etc

  def parse_date(mm_dd_yyyy_str)
    Date.strptime(mm_dd_yyyy_str, "%m/%d/%Y")
  end

end
