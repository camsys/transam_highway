class InspectionZone < ApplicationRecord

  has_many :highway_structures
  
  # All types that are available
  scope :active, -> { where(:active => true) }

  def to_s
    name
  end

end
