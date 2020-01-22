class UpdateStructuresWithoutInspTypeSettings < ActiveRecord::DataMigration
  def up
    HighwayStructure.joins('LEFT JOIN inspection_type_settings ON inspection_type_settings.transam_asset_id = highway_structures.id').where(inspection_type_settings: {transam_asset_id: nil}).each do |asset|
      puts asset.object_key

      existing_insps = asset.inspections.ids
      InspectionTypeSetting.create!(highway_structure: asset, is_required: true, inspection_type: InspectionType.find_by(name: 'Routine'), frequency_months: (['HighwaySign', 'HighwaySignal', 'HighMastLight'].include?(asset.asset_type.class_name) ? 48 : 24))

      asset.inspections.where.not(id: existing_insps).destroy_all
      asset.inspections.where.not(state: 'final').each do |insp|
        if insp.inspection_type&.can_be_recurring && insp.description.blank? # try to handle special (wont catch all)
          insp.update!(inspection_type_setting: insp.highway_structure.inspection_type_settings.find_by(inspection_type: insp.inspection_type))
        end
      end
    end
  end
end