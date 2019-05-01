class ElementDefinition < ApplicationRecord

  include TransamObjectKey

  belongs_to :element_material
  belongs_to :assembly_type
  belongs_to :element_classification

  has_many :elements
  
  has_and_belongs_to_many :defect_definitions
  
  validates :number, :uniqueness => true

  scope :is_protective, -> { where(is_protective: true) }
  scope :non_protective, -> { where(is_protective: [false, nil]) }

  def to_s
    "#{number} - #{short_name}"
  end
end
