class InspectionProgram < ApplicationRecord
  # All programs that are available
  scope :active, -> { where(:active => true) }

  def to_s
    name
  end
end
