class AddInitialFederalLandsHighwayTypes < ActiveRecord::DataMigration
  def up
    federal_lands_highway_types = [
        {active: true, code: '0', name: 'N/A', description: 'N/A'},
        {active: true, code: '1', name: 'IRR', description: 'Indian Reservation Road'},
        {active: true, code: '2', name: 'FH', description: 'Forest Highway'},
        {active: true, code: '3', name: 'LMHS', description: 'Land Management Highway System'},
        {active: true, code: '4', name: 'IRR FH', description: 'Both IRR and FH'},
        {active: true, code: '5', name: 'IRR LMHS', description: 'Both IRR and LMHS'},
        {active: true, code: '6', name: 'FH LMHS', description: 'Both FH and LMHS'},
        {active: true, code: '9', name: 'IRR FH LMHS', description: 'Combined IRR, FH and LMHS'}
    ]

    federal_lands_highway_types.each do |flht|
      FederalLandsHighwayType.find_or_create_by(flht)
    end
  end
end