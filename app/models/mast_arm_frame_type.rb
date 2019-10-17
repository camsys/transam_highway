class MastArmFrameType < ApplicationRecord

  scope :active, -> { where(active: true) }

  def to_s
    name
  end
end
