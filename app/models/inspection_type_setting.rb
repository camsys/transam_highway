class InspectionTypeSetting < ApplicationRecord

  include TransamObjectKey

  has_paper_trail if: Proc.new { |s| s.inspection_type == InspectionType.find_by(name: 'Routine') },
                  only: Rails.application.config.inspection_audit_changes.map {|x| x.split('.')[0] == self.table_name ? x.split('.')[1] : nil}.compact

  after_initialize  :set_defaults
  after_save        :update_inspection

  belongs_to :inspection_type
  belongs_to :highway_structure, foreign_key: :transam_asset_id

  attribute :calculated_inspection_due_date, :date

  def self.allowable_params
    [
        :transam_asset_id,
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



  def calculated_inspection_due_date=(value)
    if value.is_a? String
      attribute_will_change!(:calculated_inspection_due_date)
      self[:calculated_inspection_due_date] = Chronic.parse(value)
    else
      super
    end
  end

  protected
  def set_defaults
    self.is_required = self.is_required.nil? ? false : self.is_required
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
