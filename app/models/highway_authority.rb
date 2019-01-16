#------------------------------------------------------------------------------
#
# HighwayAuthority
#
# Represents an organization that manages transit operators
#
#------------------------------------------------------------------------------
class HighwayAuthority < Organization

  #------------------------------------------------------------------------------
  # Callbacks
  #------------------------------------------------------------------------------
  after_initialize  :set_defaults


  #------------------------------------------------------------------------------
  # Associations
  #------------------------------------------------------------------------------

  # every transit agency can own assets
  has_many :assets,   :foreign_key => 'organization_id', :class_name => Rails.application.config.asset_base_class_name

  # every transit agency can have 0 or more policies
  has_many :policies, :foreign_key => 'organization_id'

  has_many  :archived_fiscal_years, :foreign_key => 'organization_id'

  #------------------------------------------------------------------------------
  # Scopes
  #------------------------------------------------------------------------------
  # set the default scope
  default_scope { where(:organization_type_id => OrganizationType.find_by_class_name(self.name).id) }

  # List of allowable form param hash keys
  FORM_PARAMS = [
  ]

  #------------------------------------------------------------------------------
  #
  # Class Methods
  #
  #------------------------------------------------------------------------------

  def self.allowable_params
    FORM_PARAMS
  end

  def self.createable?
    false # only one grantor is allowed in the system and must be setup in a new app
  end

  #------------------------------------------------------------------------------
  #
  # Instance Methods
  #
  #------------------------------------------------------------------------------

  def updates_after_create
    return
  end

  # Dependent on inventory
  def has_assets?
    assets.count > 0
  end

  # returns the count of assets of the given type. If no type is selected it returns the total
  # number of assets
  def asset_count(conditions = [], values = [])
    conditions.empty? ? assets.count : assets.where(conditions.join(' AND '), *values).count
  end

  def last_archived_fiscal_year
    # force it so that if there are no archived years can only go as far back as the num forecast years
    archived_fiscal_years.order(:fy_year).last.try(:fy_year) || (current_fiscal_year_year - SystemConfig.instance.num_forecasting_years)
  end

  def first_archivable_fiscal_year
    last_archived_fiscal_year + 1
  end


  #------------------------------------------------------------------------------
  # Overrides
  #------------------------------------------------------------------------------
  def get_policy
    policies.active.first
  end

  #------------------------------------------------------------------------------
  #
  # Protected Methods
  #
  #------------------------------------------------------------------------------
  protected

  # Set resonable defaults for a new grantor
  def set_defaults
    super
    self.organization_type ||= OrganizationType.find_by_class_name(self.name).first
    self.license_holder = self.license_holder.nil? ? true : self.license_holder
  end

end
