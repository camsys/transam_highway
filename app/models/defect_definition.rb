class DefectDefinition < ApplicationRecord
  include TransamObjectKey

  has_and_belongs_to_many :element_definitions
  
  validates :number, :uniqueness => true

  def to_s
    number.to_s
  end
end
