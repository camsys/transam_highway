class Defect < ApplicationRecord

  include TransamObjectKey

  belongs_to :element
  belongs_to :defect_definition
  belongs_to :inspection
  has_one :highway_structure, through: :inspection

  scope :ordered, -> { joins(:defect_definition).merge(DefectDefinition.order(:number)) }
end
