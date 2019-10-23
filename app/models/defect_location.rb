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
end
