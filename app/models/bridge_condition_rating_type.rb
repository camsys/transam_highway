class BridgeConditionRatingType < ApplicationRecord

  # All types that are available
  scope :active, -> { where(:active => true) }

  def to_s
    "#{code} - #{name}"
  end

  # Return code as integer or nil
  def value
    i = code.to_i
    i if i.to_s == code
  end

end
