class DefectLocation < ApplicationRecord

  include TransamObjectKey

  belongs_to :defect

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
