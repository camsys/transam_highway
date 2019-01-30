class ElementDefinition < ApplicationRecord

  include TransamObjectKey

  belongs_to :element_material

end
