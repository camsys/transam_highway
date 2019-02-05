class Defect < ApplicationRecord

  include TransamObjectKey

  belongs_to :element
  belongs_to :defect_definition
  belongs_to :inspection
  belongs_to :highway_structure, through: :inspection

end
