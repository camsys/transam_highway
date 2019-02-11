class ElementDefinition < ApplicationRecord

  include TransamObjectKey

  belongs_to :element_material
  belongs_to :assembly_type
  belongs_to :element_classification

  validates :number, :uniqueness => true

  def to_s
    number.to_s
  end
end
