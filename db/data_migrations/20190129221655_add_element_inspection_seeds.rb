class AddElementInspectionSeeds < ActiveRecord::DataMigration
  def up
    element_materials = [
      {code: '_', name:	'Missing', active: true},
      {code: '0',	name: 'Unspecified', active: true},
      {code: '1',	name: 'Unpainted Steel', active: true},
      {code: '2',	name: 'Painted Steel', active: true},
      {code: '3',	name: 'Prestressed Concrete', active: true},
      {code: '4',	name: 'Reinforced Concrete', active: true},
      {code: '5',	name: 'Timber', active: true},
      {code: '6',	name: 'Other', active: true},
      {code: '7',	name: 'Decks', active: true},
      {code: '8',	name: 'Slabs', active: true},
      {code: '9',	name: 'Smart Flags', active: true}
    ]

    element_classifications = [
        {name: 'NBE', active: true}, {name: 'MBE', active: true}, {name: 'ADE', active: true}, {name: 'None', active: true}
    ]

    tables = %w{ element_materials element_classifications }

    tables.each do |table_name|
      data = eval(table_name)
      klass = table_name.classify.constantize
      data.each do |row|
        klass.create!(row)
      end
    end
  end
end