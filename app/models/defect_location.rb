class DefectLocation < ApplicationRecord

  include TransamObjectKey

  attr_accessor :global_base_imagable
  attr_accessor :image
  attr_accessor :exportable

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

  def to_s(include_note=true)
    "#{quantity} #{defect.element.element_definition.quantity_unit} of #{condition_state} #{defect.defect_definition.short_name}: #{location_description} #{(note && include_note) ? '; ' + note : ''}"
  end

    def as_json
    super.merge!({
                   "defect_number" => defect.defect_definition.number,
                   "element_number" => defect.element.element_definition.number
                 })
  end
end
