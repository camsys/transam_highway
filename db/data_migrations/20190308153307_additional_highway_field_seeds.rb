class AdditionalHighwayFieldSeeds < ActiveRecord::DataMigration
  def up
    service_on_types = [
      {active: true, code: '1',	name: 'Highway'},
      {active: true, code: '2',	name: 'Railroad'},
      {active: true, code: '3',	name: 'Pedestrian-bicycle'},
      {active: true, code: '4',	name: 'Highway-railroad'},
      {active: true, code: '5',	name: 'Highway-pedestrian'},
      {active: true, code: '6',	name: 'Overpass/Second level',	description: 'Overpass structure at an interchange or second level of a multilevel interchange'},
      {active: true, code: '7',	name: 'Third level',	description: 'Third level (Interchange)'},
      {active: true, code: '8',	name: 'Fourth level',	description: 'Fourth level (Interchange)'},
      {active: true, code: '9',	name: 'Building or plaza'},
      {active: true, code: '0',	name: 'Other'},
    ]

    service_under_types = [
      {active: true, code: '1',	name: 'Highway', description: 'Highway, with or without pedestrian'},
      {active: true, code: '2',	name: 'Railroad'},
      {active: true, code: '3',	name: 'Pedestrian-bicycle'},
      {active: true, code: '4',	name: 'Highway-railroad'},
      {active: true, code: '5',	name: 'Waterway'},
      {active: true, code: '6',	name: 'Highway-waterway'},
      {active: true, code: '7',	name: 'Railroad-waterway'},
      {active: true, code: '8',	name: 'Highway-waterway-railroad'},
      {active: true, code: '9',	name: 'Relief for waterway'},
      {active: true, code: '0',	name: 'Other'},
    ]

    historical_significance_types = [
        {active: true, code: '1',	name: 'On NHRP', description: 'Bridge is on the National Register of Historic Places(NRHP).'},
        {active: true, code: '2',	name: 'NHRP eligible', description: 'Bridge is eligible for the NRHP.'},
        {active: true, code: '3',	name: 'NHRP possible or state/local register', description: 'Bridge is possibly eligible for the NRHP(requires further investigation before determination can be made) or bridge is on a State or local historic register.'},
        {active: true, code: '4',	name: 'Cannot be determined', description: 'Historical significance is not determinable at this time. '},
        {active: true, code: '5',	name: 'Not NHRP eligible', description: 'Bridge is not eligible for the NRHP.'},
    ]

    bridge_toll_types = [
        {active: true, code: '1',	name: 'Toll bridge', description: 'Tolls are paid specifically to use the structure.'},
        {active: true, code: '2',	name: 'On toll road', description: 'The structure carries a toll road, i.e. tolls are paid to the facility, which includes
    both the highway and the structure.'},
        {active: true, code: '3',	name: 'On free road', description: 'The structure is toll-free and carries a toll-free highway.'},
        {active: true, code: '4',	name: 'On Interstate toll segment', description: 'On Interstate toll segment under Secretarial Agreement. Structure functions as a part of the toll segment.'},
        {active: true, code: '5',	name: 'Interstate toll bridge', description: 'Toll bridge is a segment under Secretarial Agreement. Structure is separate agreement from highway segment.'},
    ]

    design_load_types = [
      {active: true, code: '1',	name: 'H 10'},
      {active: true, code: '2',	name: 'H 15'},
      {active: true, code: '3',	name: 'HS 15'},
      {active: true, code: '4',	name: 'H 20'},
      {active: true, code: '5',	name: 'HS 20'},
      {active: true, code: '6',	name: 'HS 20+Mod'},
      {active: true, code: '7',	name: 'Pedestrian'},
      {active: true, code: '8',	name: 'Railroad'},
      {active: true, code: '9',	name: 'HS 25'},
      {active: true, code: '0',	name: 'Other/Unknown'},
    ]

    load_rating_method_types = [
      {active: true, code: '1',	name: 'Load Factor(LF)'},
      {active: true, code: '2',	name: 'Allowable Stress(AS)'},
      {active: true, code: '3',	name: 'Load and Resistance Factor(LRFR)'},
      {active: true, code: '4',	name: 'Load Testing'},
      {active: true, code: '5',	name: 'No rating analysis performed'},
    ]

    bridge_posting_types = [
      {active: true, code: '5',	name: 'Equal to or above legal loads'},
      {active: true, code: '4',	name: '00.1 - 09.9 % below'},
      {active: true, code: '3',	name: '10.0 - 19.9 % below'},
      {active: true, code: '2',	name: '20.0 - 29.9 % below'},
      {active: true, code: '1',	name: '30.0 - 39.9 % below'},
      {active: true, code: '0',	name: '> 39.9% below'},
    ]

    reference_feature_types = [
      {active: true, code: 'H',	name: 'Highway beneath structure'},
      {active: true, code: 'R',	name: 'Railroad beneath structure'},
      {active: true, code: 'N',	name: 'Feature not a highway or railroad'},
    ]

    seed_tables = %w{ reference_feature_types bridge_posting_types load_rating_method_types design_load_types bridge_toll_types historical_significance_types service_under_types service_on_types }

    seed_tables.each do |table_name|
      puts "  Loading #{table_name}"
      data = eval(table_name)
      klass = table_name.classify.constantize
      data.each do |row|
        klass.create!(row)
      end
    end
  end
end