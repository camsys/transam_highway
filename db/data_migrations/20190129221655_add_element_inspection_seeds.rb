class AddElementInspectionSeeds < ActiveRecord::DataMigration
  def up
    element_materials = [
      {code: '_', name:	'Missing'},
      {code: '0',	name: 'Unspecified'},
      {code: '1',	name: 'Unpainted Steel'},
      {code: '2',	name: 'Painted Steel'},
      {code: '3',	name: 'Prestressed Concrete'},
      {code: '4',	name: 'Reinforced Concrete'},
      {code: '5',	name: 'Timber'},
      {code: '6',	name: 'Other'},
      {code: '7',	name: 'Decks'},
      {code: '8',	name: 'Slabs'},
      {code: '9',	name: 'Smart Flags'}
    ]
  end
end