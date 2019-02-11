class DefectDefinition < ApplicationRecord
  include TransamObjectKey

  validates :number, :uniqueness => true

  def to_s
    number.to_s
  end
end
