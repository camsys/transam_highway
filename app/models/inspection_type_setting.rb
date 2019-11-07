class InspectionTypeSetting < ApplicationRecord

  include TransamObjectKey

  after_initialize  :set_defaults
  after_save        :update_inspection

  belongs_to :inspection_type
  belongs_to :highway_structure, foreign_key: :transam_asset_id

  attr_accessor :calculated_inspection_due_date

  def self.allowable_params
    [
        :id,
        :inspection_type_id,
        :frequency_months,
        :description,
        :is_required,
        :calculated_inspection_due_date,
        :_destroy
    ]
  end

  validates :inspection_type_id, presence: true
  validates :frequency_months, presence: true, if: :is_required

  protected
  def set_defaults
    self.is_required = self.is_required.nil? ? false : true
  end

  def update_inspection
    Rails.logger.debug "generating inspection"

    generator = InspectionGenerator.new(self)

    if self.is_required
      generator.create
    else
      generator.cancel
    end
  end

end
