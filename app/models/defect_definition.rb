class DefectDefinition < ApplicationRecord
  include TransamObjectKey

  def to_s
    number.to_s
  end
end
