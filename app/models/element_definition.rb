class ElementDefinition < ApplicationRecord

  include TransamObjectKey

  belongs_to :element_material
  belongs_to :assembly_type
  belongs_to :element_classification

  def to_s
    number
  end
end
