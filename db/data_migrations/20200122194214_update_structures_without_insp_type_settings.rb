class UpdateStructuresWithoutInspTypeSettings < ActiveRecord::DataMigration
  def up
    HighwayStructure.joins('LEFT JOIN inspection_type_settings ON inspection_type_settings.transam_asset_id = highway_structures.id').where(inspection_type_settings: {transam_asset_id: nil}).each do |asset|
      setting = InspectionTypeSetting.create!(highway_structure: asset, is_required: false, inspection_type: InspectionType.find_by(name: 'Routine'), frequency_months: (['HighwaySign', 'HighwaySignal', 'HighMastLight'].include?(asset.asset_type.class_name) ? 48 : 24))

      # set is_required without callbacks so doesnt try to generate inspection
      setting.update_columns(is_required: true)

      asset.inspections.where.not(state: 'final').each do |insp|
        if insp.inspection_type&.can_be_recurring && insp.description.blank? # try to handle special (wont catch all)
          insp.update!(inspection_type_setting: setting)
        end
      end
    end
  end
end