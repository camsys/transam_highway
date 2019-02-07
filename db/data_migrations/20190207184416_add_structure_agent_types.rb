class AddStructureAgentTypes < ActiveRecord::DataMigration
  def up
    [
        {code: '01', name: 'State Highway Agency', active: true},
        {code: '02', name: 'County Highway Agency', active: true},
        {code: '03', name: 'Town or Township Highway Agency', active: true},
        {code: '04', name: 'City or Municipal Highway Agency', active: true},
        {code: '11', name: 'State Park, Forest, or Reservation Agency', active: true},
        {code: '12', name: 'Local Park, Forest, or Reservation Agency', active: true},
        {code: '21', name: 'Other State Agencies', active: true},
        {code: '25', name: 'Other Local Agencies', active: true},
        {code: '26', name: 'Private (other than railroad)', active: true},
        {code: '27', name: 'Railroad 31 State Toll Authority', active: true},
        {code: '32', name: 'Local Toll Authority', active: true},
        {code: '60', name: 'Other Federal Agencies (not listed below)', active: true},
        {code: '61', name: 'Indian Tribal Government', active: true},
        {code: '62', name: 'Bureau of Indian Affairs', active: true},
        {code: '63', name: 'Bureau of Fish and Wildlife', active: true},
        {code: '64', name: 'U.S. Forest Service', active: true},
        {code: '66', name: 'National Park Service', active: true},
        {code: '67', name: 'Tennessee Valley Authority', active: true},
        {code: '68', name: 'Bureau of Land Management', active: true},
        {code: '69', name: 'Bureau of Reclamation', active: true},
        {code: '70', name: 'Corps of Engineers (Civil)', active: true},
        {code: '71', name: 'Corps of Engineers (Military)', active: true},
        {code: '72', name: 'Air Force', active: true},
        {code: '73', name: 'Navy/Marines', active: true},
        {code: '74', name: 'Army', active: true},
        {code: '75', name: 'NASA', active: true},
        {code: '76', name: 'Metropolitan Washington Airports Service', active: true},
        {code: '80', name: 'Unknown', active: true},

        {code: '99', name: 'Miscoded data', active: true}
    ].each do |type|
      StructureAgentType.create!(type)
    end
  end
end