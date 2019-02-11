class AddInspectionTypes < ActiveRecord::DataMigration
  def up
    [
        {code: '1', name: 'Regular NBI inspection', active: true},
        {code: '4', name: 'Special', active: true},
        {code: 'D', name: 'Underwater - Contract SCUBA', active: true},
        {code: 'L', name: 'Special - Accident Damage (traffic)', active: true},
        {code: 'M', name: 'Special - Natural Disaster Damage', description: 'Special - Natural Disaster Damage (flood, fire, wind, earthquake, etc.)', active: true},
        {code: 'O', name: 'Special - Other', active: true}
    ].each do |type|
      InspectionType.create!(type)
    end
  end
end