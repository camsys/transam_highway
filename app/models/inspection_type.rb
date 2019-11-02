class InspectionType < ApplicationRecord

  # All types that are available
  scope :active, -> { where(:active => true) }
  scope :can_be_recurring, -> { where(can_be_recurring: true) }
  scope :can_be_unscheduled, -> { where(can_be_unscheduled: true) }
  scope :not_special, -> { where.not(name: 'Special') }
  scope :special, -> { where(name: 'Special') }

  def to_s
    name
  end

end
