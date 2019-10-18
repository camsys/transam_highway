module RatableConditionType
  #-----------------------------------------------------------------------------
  #
  # RatableConditionType
  #
  # Mixin that lists sharable methods in *_condition_types
  #
  #-----------------------------------------------------------------------------
  extend ActiveSupport::Concern

  included do

    # All types that are available
    scope :active, -> { where(:active => true) }

  end

  #-----------------------------------------------------------------------------
  # Class Methods
  #-----------------------------------------------------------------------------

  #-----------------------------------------------------------------------------
  # Instance Methods
  #-----------------------------------------------------------------------------

  def to_s
    name
  end

  def name
    "#{code} - #{self[:name]}"
  end

  # Return code as integer or nil
  def value
    i = code.to_i
    i if i.to_s == code
  end
  #-----------------------------------------------------------------------------

end
