class HighwayConsultant < Organization

  #------------------------------------------------------------------------------
  # Callbacks
  #------------------------------------------------------------------------------
  after_initialize  :set_defaults


  #------------------------------------------------------------------------------
  # Associations
  #------------------------------------------------------------------------------

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
    true
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
    false
  end

  # returns the count of assets of the given type. If no type is selected it returns the total
  # number of assets
  def asset_count(conditions = [], values = [])
    0
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