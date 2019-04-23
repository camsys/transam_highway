class CulvertConditionType < ApplicationRecord
  include RatableConditionType

  def to_s
    name
  end

  def name
    "#{code} - #{self[:name]}"
  end
end
