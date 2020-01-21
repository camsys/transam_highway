class AssemblyType < ApplicationRecord

  has_and_belongs_to_many :asset_types
  
  # All types that are available
  scope :active, -> { where(:active => true) }

  def to_s
    name
  end

  def as_json(options={})
    super.merge!({"asset_types" => asset_types.pluck(:name)})
  end
end
