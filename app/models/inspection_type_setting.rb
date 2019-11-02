class InspectionTypeSetting < ApplicationRecord

  after_initialize :set_defaults

  belongs_to :inspection_type
  belongs_to :highway_structure, foreign_key: :transam_asset_id

  def self.allowable_params
    [
        :frequency_months,
        :description,
        :is_required
    ]
  end

  protected
  def set_defaults
    self.is_required = self.is_required.nil? ? false : true
  end
end
