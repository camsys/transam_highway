# An asset map searcher mixin for highway engine
#
module HighwayAssetMapSearchable

  extend ActiveSupport::Concern

  included do

    attr_accessor :region_code, :structure_status_type_code

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
    # table alias being used to avoid the case when this table is being joined in another place
    join_sql = <<-SQL 
      LEFT JOIN highway_structures 
        AS base_highway_structures
        ON base_highway_structures.id = transam_assets.transam_assetible_id AND transam_assets.transam_assetible_type = 'HighwayStructure'
      LEFT JOIN regions 
        ON base_highway_structures.region_id = regions.id
      LEFT JOIN structure_status_types 
        ON base_highway_structures.structure_status_type_id = structure_status_types.id
    SQL

    @highway_klass ||= @klass.joins(join_sql)
  end

  def region_code_conditions
    clean_region_codes = remove_blanks(region_code)
    highway_klass.where("regions.code": clean_region_codes) unless clean_region_codes.empty?
  end

  def structure_status_type_code_conditions
    clean_structure_status_type_codes = remove_blanks(structure_status_type_code)
    highway_klass.where("structure_status_types.code": clean_structure_status_type_codes) unless clean_structure_status_type_codes.empty?
  end

end