class RoadbedLine < ApplicationRecord
  include TransamObjectKey
  
  belongs_to :roadbed
  belongs_to :inspection

  scope :by_inspection, -> (inspection) { where(inspection: inspection) }

  def self.allowable_params
    [
      :entry,
      :exit
    ]
  end
end
