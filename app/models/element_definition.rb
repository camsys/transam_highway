class ElementDefinition < ApplicationRecord

  include TransamObjectKey

  belongs_to :element_material
  belongs_to :assembly_type
  belongs_to :element_classification

  has_many :elements
  
  has_and_belongs_to_many :defect_definitions
  
  validates :number, :uniqueness => true

  def to_s
    number.to_s
  end
end
