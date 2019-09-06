class AddNewInspectionPrograms < ActiveRecord::DataMigration
  def up
    programs = [
        {name: 'Central70', active: true, description: ''},
        {name: 'E470', active: true, description: ''},
        {name: 'NWP', active: true, description: ''},
        {name: 'BOR', active: true, description: ''},
        {name: 'RTD', active: true, description: ''}
    ]

    programs.each do |p|
      InspectionProgram.find_or_create_by(p)
    end
  end

  def down
    programs = ['Central70', 'E470', 'NWP', 'BOR', 'RTD']

    programs.each do |p|
      InspectionProgram.find_by(name: p).destroy
    end
  end
end