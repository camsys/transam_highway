class SeedInspectionPrograms < ActiveRecord::DataMigration
  def up
    programs = ['Ancillary', 'Minor', 'Miscellaneous', 'Inventory Only', 'Off-System', 'On-System', 'Tunnel', 'Wall']
    programs.each do |name|
      InspectionProgram.find_or_create_by({
        name: name,
        active: true
        })
    end
  end
end