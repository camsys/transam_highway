class TrafficDirectionType < ApplicationRecord
  # All types that are available
  scope :active, -> { where(:active => true) }

  def to_s
    name
  end

  def name 
    "#{code} - #{self[:name]}"
  end
end
