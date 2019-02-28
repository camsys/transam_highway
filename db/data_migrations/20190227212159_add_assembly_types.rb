class AddAssemblyTypes < ActiveRecord::DataMigration
  def up
    assembly_types = [
      {name: 'Deck', active: true}, {name: 'Superstructure', active: true}, 
      {name: 'Substructure', active: true}, {name: 'Joints', active: true}, 
      {name: 'Rails', active: true}, {name: 'Other', active: true}
    ]

    table_name = 'assembly_types'
    data = eval(table_name)
    klass = table_name.classify.constantize
    data.each do |row|
      x = klass.find_or_create_by!(row)
      instance_variable_set("@#{row[:name].downcase}", x)
    end

    deck_elements = [12, 13, 14, 15, 16, 28, 29, 30, 31, 38, 39, 54, 60, 65]
    superstructure_elements = [102, 104, 105, 106, 107, 109, 110, 111, 112, 120, 135, 136, 141, 142, 143, 144, 145, 146, 147, 149, 148, 152, 154, 155, 156, 157, 161, 162, 113, 115, 116, 117, 118]
    substructure_elements = [202, 203, 204, 205, 206, 207, 208, 210, 211, 212, 213, 215, 215, 216, 217, 218, 219, 220, 225, 226, 227, 228, 229, 231, 233, 234, 235, 236]
    joints = [300, 301, 302, 303, 304, 305, 306]
    rails = [330, 331, 332, 333, 334]
    other_elements = [510, 515, 520, 521, 320, 321]

    set_assembly(deck_elements, @deck)
    set_assembly(superstructure_elements, @superstructure)
    set_assembly(substructure_elements, @substructure)
    set_assembly(joints, @joints)
    set_assembly(rails, @rails)
    set_assembly(other_elements, @other)

    # Any element definitions not covered should also get Other
    ElementDefinition.where(assembly_type: nil).update_all(assembly_type_id: @other.id)
  end

  def set_assembly(elt_nums, type)
    elt_nums.each do |e|
      elt = ElementDefinition.find_by(number: e)
      if elt
        elt.assembly_type = type
        elt.save!
      end
    end
  end
end