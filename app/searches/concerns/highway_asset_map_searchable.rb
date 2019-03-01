# An asset map searcher mixin for highway engine
#
module HighwayAssetMapSearchable

  extend ActiveSupport::Concern

  included do

    attr_accessor :region_code, :structure_status_type_code, :owner_id

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
        LEFT JOIN highway_structures 
          ON highway_structures.id = transam_assets.transam_assetible_id AND transam_assets.transam_assetible_type = 'HighwayStructure'
        LEFT JOIN regions 
          ON highway_structures.region_id = regions.id
        LEFT JOIN structure_status_types 
          ON highway_structures.structure_status_type_id = structure_status_types.id
      SQL

      @highway_klass ||= @klass.joins(join_sql)
    elsif asset_type_class_name == 'Bridge'
      @highway_klass = @klass.left_outer_joins(highway_structure: [:region, :structure_status_type])
    elsif asset_type_class_name == 'HighwayStructure'
      @highway_klass = @klass.left_outer_joins(:region, :structure_status_type)
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

end
