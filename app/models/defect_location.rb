class DefectLocation < ApplicationRecord

  include TransamObjectKey

  belongs_to :defect
  has_one :inspection, through: :defect
  has_many :images, as: :imagable, dependent: :destroy

  def self.allowable_params
    [
        :quantity,
        :location_description,
        :location_distance,
        :condition_state,
        :note
    ]
  end

  def to_s
    "#{quantity} #{defect.element.element_definition.quantity_unit} of #{condition_state} #{defect.defect_definition.short_name}: #{location_description}; #{note}"
  end
end
