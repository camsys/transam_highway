class DefectDefinition < ApplicationRecord
  include TransamObjectKey

  def to_s
    number
  end
end
