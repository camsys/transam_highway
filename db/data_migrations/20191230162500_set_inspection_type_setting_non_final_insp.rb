class SetInspectionTypeSettingNonFinalInsp < ActiveRecord::DataMigration
  def up
    Inspection.where.not(state: 'final').each do |insp|
      if insp.inspection_type&.can_be_recurring && insp.description.blank? # try to handle special (wont catch all)
        insp.update!(inspection_type_setting: insp.highway_structure.inspection_type_settings.find_by(inspection_type: insp.inspection_type))
      end
    end
  end
end