class Inspection < ApplicationRecord

  actable as: :inspectionible

  include TransamObjectKey

  belongs_to :highway_structure, foreign_key: :transam_asset_id

  belongs_to :inspection_type

  has_and_belongs_to_many :inspectors, class_name: 'User', join_table: 'inspections_users'

  has_many :elements, dependent: :destroy

  scope :ordered, -> { order(event_datetime: :desc) }

  def self.get_typed_inspection(inspection)
    if inspection
      if inspection.specific
        inspection = inspection.specific

        typed_asset = TransamAsset.get_typed_asset(inspection.highway_structure)
        if typed_asset.class.to_s == 'Bridge'
          inspection = inspection.becomes(BridgeCondition)
        elsif typed_asset.class.to_s == 'Culvert'
          inspection = inspection.becomes(CulvertCondition)
        end
      end

      inspection
    end
  end
end
