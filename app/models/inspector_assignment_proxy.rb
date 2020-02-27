class InspectorAssignmentProxy < Proxy

  attr_accessor   :is_removal
  attr_accessor   :global_ids
  attr_accessor   :inspector_ids
  attr_accessor   :inspections

  def self.allowable_params
    [
        :is_removal,
        :inspector_ids => [],
        :global_ids => []
    ]
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

    h[:transam_workflow_model_proxy] = a
    h.with_indifferent_access
  end

  protected

  def initialize(attrs = {})
    super
    attrs.each do |k, v|
      self.send "#{k}=", v
    end

    self.inspections = []
    self.global_ids.each do |global_id|
      inspections << GlobalID::Locator.locate(global_id)
    end
  end

end