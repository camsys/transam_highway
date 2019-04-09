#-------------------------------------------------------------------------------
# InspectionProxy
#
# Proxy class for gathering inspection search parameters
#
#-------------------------------------------------------------------------------
class InspectionProxy < Proxy

  #-----------------------------------------------------------------------------
  # Attributes
  #-----------------------------------------------------------------------------
  # new_search: Flag to indicate if the search has been reset or is new. Values are '1' (new search) or '0'
  attr_accessor   :new_search, 
                  :asset_tag, :region_code, :structure_status_type_code, :owner_id, 
                  :calculated_condition,
                  :on_under_indicator, :service_on_type_id, :service_under_type_id,
                  :on_national_highway_system, :structure_county, :structure_city,
                  :inspection_program_id, :organization_type_id, :assigned_organization_id,
                  :state, :min_next_inspection_date, :max_next_inspection_date, 
                  :min_inspection_date, :max_inspection_date,
                  :inspection_frequency, :inspector_id, :qa_inspector_id, :qc_inspector_id, 
                  :inspection_trip, :inspection_zone

  #-----------------------------------------------------------------------------
  # Validations
  #-----------------------------------------------------------------------------

  #-----------------------------------------------------------------------------
  # Constants
  #-----------------------------------------------------------------------------

  # List of allowable form param hash keys

  FORM_PARAMS = [
    :asset_tag, :on_under_indicator, :structure_county, :structure_city, :on_national_highway_system,
    :min_next_inspection_date, :max_next_inspection_date,
    :min_inspection_date, :max_inspection_date,
    :assigned_organization_id, :inspection_program_id, :organization_type_id, 
    :inspection_frequency, :inspector_id, :qa_inspector_id, :qc_inspector_id,
    :inspection_trip, :inspection_zone
  ]

  NESTED_FORM_PARAMS = [
    { :region_code => [] }, 
    { :service_on_type_id => [] }, 
    { :service_under_type_id => [] }, 
    { :owner_id => [] }, 
    { :structure_status_type_code => [] }, 
    { :calculated_condition => [] },
    { :state => [] }
  ]

  #-----------------------------------------------------------------------------
  #
  # Class Methods
  #
  #-----------------------------------------------------------------------------

  def self.allowable_params
    FORM_PARAMS + NESTED_FORM_PARAMS
  end

  #-----------------------------------------------------------------------------
  #
  # Instance Methods
  #
  #-----------------------------------------------------------------------------

  #-----------------------------------------------------------------------------
  # Returns the search proxy as hash as if a form had been submitted
  #-----------------------------------------------------------------------------
  def to_h
    h = {}
    a = {}
    FORM_PARAMS.each do |param|
      a[param] = self.try(param) unless self.try(param).blank?
    end

    NESTED_FORM_PARAMS.each do |param|
      p_key = param.keys.first
      a[p_key] = self.try(p_key) unless self.try(p_key).blank?
    end
    
    h[:inspection_proxy] = a
    h.with_indifferent_access
  end

  #-----------------------------------------------------------------------------
  #
  # Protected Methods
  #
  #-----------------------------------------------------------------------------
  protected

  def initialize(attrs = {})
    super
    attrs.each do |k, v|
      self.send "#{k}=", v
    end

    self.new_search ||= '1'
  end

end
