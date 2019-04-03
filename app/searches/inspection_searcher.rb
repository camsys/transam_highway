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
      LEFT OUTER JOIN structure_status_types 
        ON highway_structures.structure_status_type_id = structure_status_types.id
      LEFT OUTER JOIN bridge_likes 
        ON highway_structures.highway_structurible_id = bridge_likes.id AND highway_structures.highway_structurible_type = 'BridgeLike'
      LEFT OUTER JOIN roadways 
        ON highway_structures.id = roadways.transam_asset_id
    SQL

    @inspection_klass ||= Inspection.joins(highway_structure: :transam_asset).joins(join_sql)
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

end
