# An asset map searcher mixin for highway engine
#
module HighwayAssetMapSearchable

  extend ActiveSupport::Concern

  included do

    attr_accessor :region_code, :structure_status_type_code, :owner_id, :calculated_condition,
                  :on_under_indicator, :service_on_type_id, :service_under_type_id,
                  :on_national_highway_system

  end

  #------------------------------------------------------------------------------
  #
  # Class Methods
  #
  #------------------------------------------------------------------------------
  module ClassMethods

  end
  #------------------------------------------------------------------------------
  #
  # Instance Methods
  #
  #------------------------------------------------------------------------------
  private

  def highway_klass
    if asset_type_class_name == 'TransamAsset'
      # table alias being used to avoid the case when this table is being joined in another place
      join_sql = <<-SQL 
        LEFT OUTER JOIN highway_structures 
          ON highway_structures.id = transam_assets.transam_assetible_id AND transam_assets.transam_assetible_type = 'HighwayStructure'
        LEFT OUTER JOIN regions 
          ON highway_structures.region_id = regions.id
        LEFT OUTER JOIN structure_status_types 
          ON highway_structures.structure_status_type_id = structure_status_types.id
        LEFT OUTER JOIN bridges 
          ON highway_structures.highway_structurible_id = bridges.id AND highway_structures.highway_structurible_type = 'Bridge'
        LEFT OUTER JOIN roadways 
          ON highway_structures.id = roadways.transam_asset_id
      SQL

      @highway_klass ||= @klass.joins(join_sql)
    elsif asset_type_class_name == 'Bridge'
      @highway_klass = @klass.left_outer_joins(:service_on_type, :service_under_type, :highway_structure => [:region, :structure_status_type, :roadways])
    elsif asset_type_class_name == 'HighwayStructure'
      join_sql = <<-SQL 
        LEFT OUTER JOINS bridges 
          ON highway_structures.highway_structurible_id = bridges.id AND highway_structures.highway_structurible_type = 'Bridge'
      SQL

      @highway_klass = @klass.left_outer_joins(:region, :structure_status_type, :roadways)
                      .joins(join_sql)
    end
  end

  def region_code_conditions
    clean_region_codes = remove_blanks(region_code)
    highway_klass.where("regions.code": clean_region_codes) unless clean_region_codes.empty?
  end

  def structure_status_type_code_conditions
    clean_structure_status_type_codes = remove_blanks(structure_status_type_code)
    highway_klass.where("structure_status_types.code": clean_structure_status_type_codes) unless clean_structure_status_type_codes.empty?
  end

  def owner_id_conditions
    highway_klass.where("highway_structures.owner_id": owner_id) unless owner_id.blank?
  end

  def calculated_condition_conditions
    clean_condition_codes = remove_blanks(calculated_condition)
    highway_klass.where("highway_structures.calculated_condition": clean_condition_codes) unless clean_condition_codes.empty?
  end

  def service_on_type_id_conditions
    clean_service_on_type_ids = remove_blanks(service_on_type_id)
    highway_klass.where("bridges.service_on_type_id": clean_service_on_type_ids) unless clean_service_on_type_ids.empty?
  end

  def service_under_type_id_conditions
    clean_service_under_type_ids = remove_blanks(service_under_type_id)
    highway_klass.where("bridges.service_under_type_id": clean_service_under_type_ids) unless clean_service_under_type_ids.empty?
  end

  def on_national_highway_system_conditions
    highway_klass.where("roadways.on_national_highway_system": on_national_highway_system == 'yes') unless on_national_highway_system.blank?
  end
end
