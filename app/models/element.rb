class Element < ApplicationRecord

  include TransamObjectKey

  belongs_to :parent, class_name: 'Element', foreign_key: :parent_element_id
  has_many :children, class_name: 'Element', foreign_key: :parent_element_id, dependent: :destroy
  belongs_to :element_definition
  belongs_to :inspection
  has_one :highway_structure, through: :inspection
  has_many :defects, dependent: :destroy
  has_many :images, as: :imagable, dependent: :destroy

  scope :ordered, -> { joins(:element_definition).merge(ElementDefinition.order(:number)) }

  def self.allowable_params
    [
      :element_definition_id,
      :parent_element_id,
      :inspection_id,
      :quantity,
      :notes
    ]
  end

  def as_json
    super.merge!({
                   "element_number" => element_definition.number
                 })
  end

  # Can't set quantity less than sum of defects
  def min_quantity
    DefectLocation.where(defect_id: defects).sum(&:quantity)
  end
end
