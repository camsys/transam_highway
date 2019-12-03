class UpdateInspectionTypesData < ActiveRecord::DataMigration
  def up
    [{code: '1', name: 'Routine', active: true, can_be_recurring: true, can_be_unscheduled: false},
     {code: 'U', name: 'Underwater', active: true, can_be_recurring: true, can_be_unscheduled: false},
     {code: 'G', name: 'Fracture Critical', active: true, can_be_recurring: true, can_be_unscheduled: false},
     {code: 'P', name: 'Special Pin', active: true, can_be_recurring: true, can_be_unscheduled: false},
     {code: '4', name: 'Special', active: true, can_be_recurring: true, can_be_unscheduled: true},
     {code: '2', name: 'Initial', active: true, can_be_unscheduled: true},
     {code: '3', name: 'Damage', active: true, can_be_unscheduled: true},
     {code: '6', name: 'In-depth', active: true, can_be_unscheduled: true}].each do |type|

      inspection_type = InspectionType.find_by(code: type[:code])

      if inspection_type
        inspection_type.update!(name: type[:name], can_be_recurring: type[:can_be_recurring], can_be_unscheduled: type[:can_be_unscheduled])
      elsif type[:code] == 'U'
        inspection_type = InspectionType.find_by(code: 'D')
        inspection_type.update!(name: type[:name], code: type[:code], can_be_recurring: type[:can_be_recurring], can_be_unscheduled: type[:can_be_unscheduled])
      else
        InspectionType.create!(name: type[:name], code: type[:code], active: true, can_be_recurring: type[:can_be_recurring], can_be_unscheduled: type[:can_be_unscheduled])
      end
    end

    # update special
    special_inspection_type = InspectionType.find_by(code: '4')
    old_special_inspection_types = InspectionType.where('name LIKE ?', "#{'Special'}%").where.not(code: special_inspection_type.code)
    Inspection.where(inspection_type: old_special_inspection_types).update_all(inspection_type_id: special_inspection_type.id)
    old_special_inspection_types.destroy_all



  end
end

