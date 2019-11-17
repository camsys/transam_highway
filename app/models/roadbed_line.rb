class RoadbedLine < ApplicationRecord
  include TransamObjectKey

  belongs_to :roadbed
  belongs_to :inspection

  scope :lines, -> { where.not(number: ['L', 'R']).order(:number) }
  scope :by_inspection, -> (inspection) { where(inspection: inspection) }

  def self.allowable_params
    [
      :entry,
      :exit,
      :minimum_clearance
    ]
  end

  def has_no_restrictions?
    entry.nil? && exit.nil?
  end

  def not_applicable?
    entry.zero? && exit.zero?
  end
end
