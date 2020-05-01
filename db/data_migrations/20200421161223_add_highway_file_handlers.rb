class AddHighwayFileHandlers < ActiveRecord::DataMigration
  def up
    file_content_types = [
        {:active => 1, :name => 'Inspection Updates',    :class_name => 'InspectionUpdatesFileHandler', :description => 'Worksheet records updates for existing inspections.'},
        {:active => 1, :name => 'Highway Structure Updates',  :class_name => 'HighwayStructureUpdatesFileHandler', :description => 'Worksheet records updates for existing highway structures'},
        {:active => 1, :name => 'Roadway Updates',    :class_name => 'RoadwayUpdatesFileHandler', :description => 'Worksheet records updates for existing roadways.'}
    ]

    FileContentType.where(class_name: ['InventoryUpdatesFileHandler', 'MaintenanceUpdatesFileHandler', 'DispositionUpdatesFileHandler', 'NewInventoryFileHandler']).update_all(active: false)

    file_content_types.each do |fct|
      FileContentType.find_or_create_by(fct)
    end
  end
end