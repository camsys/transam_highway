class AddInitialMedianTypes < ActiveRecord::DataMigration
  def up
    median_types = [
        {active: true, code: '0', name: 'None', description: 'No median'},
        {active: true, code: '1', name: 'Open', description: 'Open median'},
        {active: true, code: '2', name: 'Closed no barrier', description: 'Closed median (no barrier)'},
        {active: true, code: '3', name: 'Closed barrier', description: 'Closed median with non-mountable barriers'}
    ]

    median_types.each do |mt|
      MedianType.find_or_create_by(mt)
    end
  end
end