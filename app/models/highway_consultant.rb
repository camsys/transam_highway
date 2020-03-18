class HighwayConsultant < Organization

  #------------------------------------------------------------------------------
  # Callbacks
  #------------------------------------------------------------------------------
  after_initialize  :set_defaults


  #------------------------------------------------------------------------------
  # Associations
  #------------------------------------------------------------------------------

  has_and_belongs_to_many :highway_consultants,
                          :join_table => :highway_consultants_organizations,
                          :foreign_key => :organization_id,
                          :association_foreign_key => :highway_consultant_id

  #------------------------------------------------------------------------------
  # Scopes
  #------------------------------------------------------------------------------
  # set the default scope
  default_scope { where(:organization_type_id => OrganizationType.find_by_class_name(self.name).id) }

  # List of allowable form param hash keys
  FORM_PARAMS = [
      :highway_consultant_ids
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
    User.with_role(:manager).where(organization_id: HighwayAuthority.first.id).each do |user|
      user.viewable_organizations << self
    end
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
    self.license_holder = self.license_holder.nil? ? false : self.license_holder
  end

  def after_add_highway_consultant_callback(highway_consultant)
    User.active.joins(:organizations).where(organizations: {id: self.id}).each do |u|
      u.viewable_organizations << highway_consultant
    end
  end

  def after_remove_highway_consultant_callback(highway_consultant)
    User.active.joins(:organizations).where(organizations: {id: self.id}).each do |u|
      u.viewable_organizations.destroy(highway_consultant)
    end
  end

end