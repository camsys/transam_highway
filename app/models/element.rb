class Element < ApplicationRecord

  include TransamObjectKey

  belongs_to :parent, class_name: 'Element'
  belongs_to :element_definition
  belongs_to :inspection
  belongs_to :highway_structure, through: :inspection
end
