class FixStructureAgentTypesSeeds < ActiveRecord::DataMigration
  def up
    type_27 = StructureAgentType.find_by_code('27')
    type_27.update(name: 'Railroad') if type_27

    type_31 = StructureAgentType.find_or_create_by(code: '31', name: 'State Toll Authority')
    type_31.update(active: true) if type_31
  end
end