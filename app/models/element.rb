class Element < ApplicationRecord

  include TransamObjectKey

  belongs_to :parent, class_name: 'Element', foreign_key: :parent_element_id
  belongs_to :element_definition
  belongs_to :inspection
  has_one :highway_structure, through: :inspection
  has_many :defects, dependent: :destroy
end
