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

  def region_code_conditions
  end

  def structure_status_type_code_conditions
  end

end
