class DesignConstructionType < ApplicationRecord

  belongs_to :asset_subtype

  # All types that are available
  scope :active, -> { where(:active => true) }

  def to_s
    name
  end

  def name 
    "#{code} - #{self[:name]}"
  end
end
