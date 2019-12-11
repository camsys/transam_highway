class AddReferenceInspectionTypeSettingInspections < ActiveRecord::Migration[5.2]
  def change
    add_reference :inspections, :inspection_type_setting, after: :inspection_type_id
  end
end
