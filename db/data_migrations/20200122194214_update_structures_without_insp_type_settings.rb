class UpdateStructuresWithoutInspTypeSettings < ActiveRecord::DataMigration
  def up
    HighwayStructure.joins('LEFT JOIN inspection_type_settings ON inspection_type_settings.transam_asset_id = highway_structures.id').where(inspection_type_settings: {transam_asset_id: nil}).each do |asset|
      InspectionTypeSetting.create!(highway_structure: asset, is_required: true, inspection_type: InspectionType.find_by(name: 'Routine'), frequency_months: (['HighwaySign', 'HighwaySignal', 'HighMastLight'].include?(asset.asset_type.class_name) ? 48 : 24))
    end
  end
end