class Defect < ApplicationRecord

  include TransamObjectKey

  belongs_to :element
  belongs_to :defect_definition
  belongs_to :inspection
  has_one :highway_structure, through: :inspection
  has_many :images, as: :imagable, dependent: :destroy

  scope :ordered, -> { joins(:defect_definition).merge(DefectDefinition.order(:number)) }

  def self.allowable_params
    [
      :element_id, 
      :defect_definition_id, 
      :inspection_id, :condition_state_1_quantity,
      :condition_state_2_quantity,
      :condition_state_3_quantity,
      :condition_state_4_quantity,
      :total_quantity,
      :notes
    ]
  end
end
