class AssemblyType < ApplicationRecord

  has_and_belongs_to_many :asset_types

  # All types that are available
  scope :active, -> { where(:active => true) }

  def to_s
    name
  end

  def as_json(options={})
    super.merge!({"asset_type_ids" => asset_types.pluck(:id)})
  end
end
