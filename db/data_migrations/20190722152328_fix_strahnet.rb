class FixStrahnet < ActiveRecord::DataMigration
  def up
    [{code: '0', name: 'Not STRAHNET'},
     {code: '1', name: 'Interstate STRAHNET'},
     {code: '2', name: 'Non-Interstate STRAHNET'}, 
     {code: '3', name: 'Connector STRAHNET'}].each do |type|
      StrahnetDesignationType.find_by(name: type[:name]).update_attributes(code: type[:code])
    end
  end
end
