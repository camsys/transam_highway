#encoding: utf-8

# determine if we are using postgres or mysql
is_mysql = (ActiveRecord::Base.configurations[Rails.env]['adapter'].include?'mysql2')
is_sqlite =  (ActiveRecord::Base.configurations[Rails.env]['adapter'] == 'sqlite3')

puts "======= Updating TransAM Highway Seed  ======="

organization_types = [
    {
        :active => 1, :name => 'Highway Authority', :class_name => "HighwayAuthority",
        :display_icon_name => "fa fa-highway", :map_icon_name => "redIcon",
        :description => 'Manage highway structures, bridges.'
    }
]
asset_types = [
    {name: 'Bridge', description: 'Bridge', class_name: 'Bridge', display_icon_name: 'fa fa-road', map_icon_name: 'blueIcon', active: true}
]
asset_subtypes = [
  {belongs_to: 'asset_type', type: 'Bridge', name: 'Arch', description: 'Arched Bridge', active: true},
  {belongs_to: 'asset_type', type: 'Bridge', name: 'Beam', description: 'Beam Bridge', active: true},
  {belongs_to: 'asset_type', type: 'Bridge', name: 'Slab', description: 'Slab Bridge', active: true},
  {belongs_to: 'asset_type', type: 'Bridge', name: 'Suspension', description: 'Suspension Bridge', active: true},
  {belongs_to: 'asset_type', type: 'Bridge', name: 'Truss', description: 'Truss Bridge', active: true},
  {belongs_to: 'asset_type', type: 'Bridge', name: 'Other', description: 'Other Bridge', active: true}
]
system_config_extensions = [
    {class_name: 'HighwayStructure', extension_name: 'TransamCoordinateLocatable', active: true}
]

route_signing_prefixes = [
  {active: true, code: '1',	name: 'Interstate'},
  {active: true, code: '2', name:	'U.S. Highway'},
  {active: true, code: '3', name:	'State highway'},
  {active: true, code: '4', name:	'County highway'},
  {active: true, code: '5', name:	'City street'},
  {active: true, code: '6', name:	'Federal lands road'},
  {active: true, code: '7', name:	'State lands road'},
  {active: true, code: '8', name:	'Other'}
]
operational_status_types = [
    {active: true, code: 'A',	name: 'Open', description:	'Open, no restriction'},
    {active: true, code: 'B',	name: 'Posting Recommended', description: 'Open, posting recommended but not legally implemented (all signs not in place or not correctly implemented)'},
    {active: true, code: 'D', name:	'Temporary Shoring', description:	'Open, would be posted or closed except for temporary shoring, etc. to allow for unrestricted traffic'},
    {active: true, code: 'E',	name: 'Temporary Structure', description:	'Open, temporary structure in place to carry legal loads while original structure is closed and awaiting replacement or rehabilitation'},
    {active: true, code: 'G', name:	'New Structure', description:	'New structure not yet open to traffic'},
    {active: true, code: 'K', name:	'Closed',	description: 'Bridge closed to all traffic'},
    {active: true, code: 'P',	name: 'Posted Load Restriction', description:	'Posted for load (may include other restrictions such as temporary bridges which are load posted)'},
    {active: true, code: 'R', name:	'Posted Other Restriction', description: 'Posted for other load-capacity restriction (speed, number of vehicles on bridge, etc.)'}
]

structure_material_types = [
    {active: true, code: '1',	name: 'Concrete'},
    {active: true, code: '2', name:	'Concrete continuous'},
    {active: true, code: '3', name:	'Steel'},
    {active: true, code: '4',	name: 'Steel continuous'},
    {active: true, code: '5', name:	'Prestressed concrete'},
    {active: true, code: '6',	name: 'Prestressed concrete continuous'},
    {active: true, code: '7', name:	'Wood or Timber'},
    {active: true, code: '8', name:	'Masonry'},
    {active: true, code: '9', name:	'Aluminum, Wrought Iron, or Cast Iron'},
    {active: true, code: '0', name:	'Other'}
]
design_construction_types = [
  {active: true, code: '01', name:	'Slab', belongs_to: 'asset_subtype', type: 'Slab'},
  {active: true, code: '02', name:	'Stringer/Multi-beam or Girder', belongs_to: 'asset_subtype', type: 'Beam'},
  {active: true, code: '03', name:	'Girder and Floorbeam System', belongs_to: 'asset_subtype', type: 'Beam'},
  {active: true, code: '04', name:	'Tee Beam', belongs_to: 'asset_subtype', type: 'Beam'},
  {active: true, code: '05', name:	'Box Beam or Girders - Multiple', belongs_to: 'asset_subtype', type: 'Beam'},
  {active: true, code: '06', name:	'Box Beam or Girders - Single or Spread', belongs_to: 'asset_subtype', type: 'Beam'},
  {active: true, code: '07', name:	'Frame (except frame culverts)', belongs_to: 'asset_subtype', type: 'Beam'},
  {active: true, code: '08', name:	'Orthotropic', belongs_to: 'asset_subtype', type: 'Beam'},
  {active: true, code: '09', name:	'Truss - Deck', belongs_to: 'asset_subtype', type: 'Truss'},
  {active: true, code: '10', name:	'Truss - Thru', belongs_to: 'asset_subtype', type: 'Truss'},
  {active: true, code: '11', name:	'Arch - Deck', belongs_to: 'asset_subtype', type: 'Arch'},
  {active: true, code: '12', name:	'Arch - Thru', belongs_to: 'asset_subtype', type: 'Arch'},
  {active: true, code: '13', name:	'Suspension', belongs_to: 'asset_subtype', type: 'Suspension'},
  {active: true, code: '14', name:	'Stayed Girder', belongs_to: 'asset_subtype', type: 'Suspension'},
  {active: true, code: '15', name:	'Movable - Lift', belongs_to: 'asset_subtype', type: 'Other'},
  {active: true, code: '16', name:	'Movable - Bascule', belongs_to: 'asset_subtype', type: 'Other'},
  {active: true, code: '17', name:	'Movable - Swing', belongs_to: 'asset_subtype', type: 'Other'},
  {active: true, code: '18', name:	'Tunnel', belongs_to: 'asset_subtype', type: 'Other'},
  {active: true, code: '19', name:	'Culvert (includes frame culverts)', belongs_to: 'asset_subtype', type: 'Other'},
  {active: true, code: '20', name:	'Mixed types', belongs_to: 'asset_subtype', type: 'Other'},
  {active: true, code: '21', name: 'Segmental Box Girder', belongs_to: 'asset_subtype', type: 'Beam'},
  {active: true, code: '22', name:	'Channel Beam', belongs_to: 'asset_subtype', type: 'Beam'},
  {active: true, code: '00', name:	'Other', belongs_to: 'asset_subtype', type: 'Other'}
]
bridge_condition_rating_types = [
  {active: true, code: 'N', name:	'Not Applicable'},
  {active: true, code: '9', name:	'Excellent'},
  {active: true, code: '8', name:	'Very Good', description:	'No problems noted'},
  {active: true, code: '7', name:	'Good', description:	'Some minor problems'},
  {active: true, code: '6', name:	'Satisfactory', description:	'Structural elements show some minor deterioration'},
  {active: true, code: '5', name:	'Fair', description:	'All primary structural elements are sound but may have minor section loss, cracking, spalling or scour'},
  {active: true, code: '4', name:	'Poor', description:	'Advanced section loss, deterioration, spalling or scour'},
  {active: true, code: '3', name:	'Serious', description:	'Loss of section, deterioration, spalling or scour have seriously affected primary structural components. Local failures are possible. Fatigue cracks in steel or shear cracks in concrete may be present'},
  {active: true, code: '2', name:	'Critical', description:	'Advanced deterioration of primary structural elements. Fatigue cracks in steel or shear cracks in concrete may be present or scour may have removed substructure support. Unless closely monitored it may be necessary to close the bridge until corrective action is taken'},
  {active: true, code: '1', name:	'Imminent Failure', description:	'Major deterioration or section loss present in critical structural components or obvious vertical or horizontal movement affecting structure stability. Bridge is closed to traffic but corrective action may put back in light service'},
  {active: true, code: '0', name:	'Failed', description:	'Out of service - beyond corrective action'}
]
channel_condition_types = [
    {active: true, code: 'N', name:	'Not Applicable', description:	'Use when bridge is not over a waterway (channel).'},
    {active: true, code: '9', name:	'No Deficiencies', description:	'There are no noticeable or noteworthy deficiencies which affect the condition of the channel.'},
    {active: true, code: '8', name:	'Stable', description:	'Banks are protected or well vegetated. River control devices such as spur dikes and embankment protection are not required or are in a stable condition.'},
    {active: true, code: '7', name:	'Minor Issues', description:	'Bank protection is in need of minor repairs. River control devices and embankment protection have a little minor damage. Banks and/or channel have minor amounts of drift.'},
{active: true, code: '6', name:	'Significant Issues', description:	'Bank is beginning to slump. River control devices and embankment protection have widespread minor damage. There is minor stream bed movement evident. Debris is restricting the channel slightly.'},
{active: true, code: '5', name:	'Major Issues', description:	'Bank protection is being eroded. River control devices and/or embankment have major damage. Trees and brush restrict the channel.'},
    {active: true, code: '4', name:	'Severe Feature Damage', description:	'Bank and embankment protection is severely undermined. River control devices have severe damage. Large deposits of debris are in the channel.'},
    {active: true, code: '3', name:	'Failed Features', description:	'Bank protection has failed. River control devices have been destroyed. Stream bed aggradation, degradation or lateral movement has changed the channel to now threaten the bridge and/or approach roadway.'},
{active: true, code: '2', name:	'Bridge Collapse Imminent', description:	'The channel has changed to the extent the bridge is near a state of collapse.'},
{active: true, code: '1', name:	'Closed Pending Repairs', description:	'Bridge closed because of channel failure. Corrective action may put back in light service.'},
{active: true, code: '0', name:	'Closed Pending Replacement', description: 'Bridge closed because of channel failure. Replacement necessary.'}
]

bridge_appraisal_rating_types = [
  {active: true, code: 'N', name:	'Not Applicable'},
  {active: true, code: '9', name:	'Superior', description:	'Superior to present desirable criteria'},
  {active: true, code: '8', name:	'Meets Desires', description:	'Equal to present desirable criteria'},
  {active: true, code: '7', name:	'Exceeds Requirements', description:	'Better than present minimum criteria'},
  {active: true, code: '6', name:	'Meets Requirements', description:	'Equal to present minimum criteria'},
  {active: true, code: '5', name:	'Tolerable', description:	'Somewhat better than minimum adequacy to tolerate being left in place as is'},
  {active: true, code: '4', name:	'Barely Tolerable', description:	'Meets minimum tolerable limits to be left in place as is'},
  {active: true, code: '3', name:	'Intolerable Must Repair', description:	'Basically intolerable requiring high priority of corrective action'},
  {active: true, code: '2', name:	'Intolerable Must Replace', description:	'Basically intolerable requiring high priority of replacement'},
  {active: true, code: '0', name:	'Closed', description:	'Bridge closed'}
]
strahnet_designation_types = [
    {active: true, code: '1', name:	'Not STRAHNET', description:	'The inventory route is not a STRAHNET route.'},
    {active: true, code: '2', name:	'Interstate STRAHNET', description:	'The inventory route is on a Interstate STRAHNET route.'},
    {active: true, code: '3', name:	'Non-Interstate STRAHNET', description:	'The inventory route is on a Non-Interstate STRAHNET route.'},
    {active: true, code: '4', name:	'Connector STRAHNET', description:	'The inventory route is on a STRAHNET connector route.'}
]
deck_structure_types = [
  {active: true, code: '1', name:	'Concrete Cast-in-Place'},
  {active: true, code: '2', name:	'Concrete Precast Panels'},
  {active: true, code: '3', name:	'Open Grating'},
  {active: true, code: '4', name:	'Closed Grating'},
  {active: true, code: '5', name:	'Steel plate (includes orthotropic)'},
  {active: true, code: '6', name:	'Corrugated Steel'},
  {active: true, code: '7', name:	'Aluminum'},
  {active: true, code: '8', name:	'Wood or Timber'},
  {active: true, code: '9', name:	'Other'},
  {active: true, code: 'N', name:	'Not applicable'}
]
wearing_surface_types = [
  {active: true, code: '1', name:	'Monolithic Concrete', description:	'(concurrently placed with structural deck)'},
  {active: true, code: '2', name:	'Integral Concrete', description: '(separate non-modified layer of concrete added to structural deck)'},
  {active: true, code: '3', name:	'Latex Concrete', description: '(or similar additive)'},
  {active: true, code: '4', name:	'Low slump Concrete'},
  {active: true, code: '5', name:	'Epoxy Overlay'},
  {active: true, code: '6', name:	'Bituminous'},
  {active: true, code: '7', name:	'Wood or Timber'},
  {active: true, code: '8', name:	'Gravel'},
  {active: true, code: '9', name:	'Other'},
  {active: true, code: '0', name:	'None', description:	'(no additional concrete thickness or wearing surface is included in the bridge deck)'},
  {active: true, code: 'N', name:	'Not applicable', description:	'(applies only to structures with no deck)'}
]
membrane_types = [
  {active: true, code: '1', name:	'Built-up'},
  {active: true, code: '2', name:	'Preformed Fabric'},
  {active: true, code: '3', name:	'Epoxy'},
  {active: true, code: '8', name:	'Unknown'},
  {active: true, code: '9', name:	'Other'},
  {active: true, code: '0', name:	'None'},
  {active: true, code: 'N', name:	'Not applicable'}
]
deck_protection_types = [
  {active: true, code: '1', name:	'Epoxy Coated Reinforcing'},
  {active: true, code: '2', name:	'Galvanized Reinforcing'},
  {active: true, code: '3', name:	'Other Coated Reinforcing'},
  {active: true, code: '4', name:	'Cathodic Protected'},
  {active: true, code: '6', name:	'Polymer Impregnated'},
  {active: true, code: '7', name:	'Internally Sealed'},
  {active: true, code: '8', name:	'Unknown'},
  {active: true, code: '9', name:	'Other'},
  {active: true, code: '0', name:	'None'},
  {active: true, code: 'N', name:	'Not applicable'}
]
scour_critical_bridge_types = [
  {active: true, code: 'N', name:	'Not over waterway', description:	'Bridge not over waterway.'},
  {active: true, code: 'U', name:	'Unknown', description:	'Bridge with "unknown" foundation that has not been evaluated for scour. Until risk can be determined, a plan of action should be developed and implemented to reduce the risk to users from abridge failure during and immediately after a flood event.'},
  {active: true, code: '9', name:	'Dry', description:	'Bridge foundations (including piles) on dry land well above flood water elevations.'},
  {active: true, code: '8', name:	'Stable, above footing', description:	'Bridge foundations determined to be stable for the assessed or calculated scour condition. Scour is determined to be above top of footing by assessment, by calculation, or by installation of properly designed countermeasures.'},
  {active: true, code: '7', name:	'Has Counter measures', description:	'Countermeasures have been installed to mitigate an existing problem with scour and to reduce the risk of bridge failure during a flood event. Instructions contained in a plan of action have been implemented to reduce the risk to users from a bridge failure during or immediately after a flood event.'},
  {active: true, code: '6', name:	'Not evaluated', description:	'Scour calculation/evaluation has not been made. (Use only to describe case where bridge has not yet been evaluated for scour potential.)'},
  {active: true, code: '5', name:	'Stable, within limits', description:	'Bridge foundations determined to be stable for assessed or calculated scour condition. Scour is determined to be within the limits of footing or piles by assessment, by calculations or by installation of properly designed countermeasures.'},
  {active: true, code: '4', name:	'Stable, action required', description:	'Bridge foundations determined to be stable for assessed or calculated scour conditions;field review indicates action is required to protect exposed foundations.'},
  {active: true, code: '3', name:	'Critical, unstable', description:	'Bridge is scour critical; bridge foundations determined to be unstable for assessed or calculated scour conditions:Scour within limits of footing or piles.Scour below spread-footing base or pile tips.'},
  {active: true, code: '2', name:	'Critical, immediate action required', description:	'Bridge is scour critical; field review indicates that extensive scour has occurred at bridge foundations. Immediate action is required to provide scour countermeasures.'},
  {active: true, code: '1', name:	'Failure imminent', description:	'Bridge is scour critical; field review indicates that failure of piers/abutments is imminent. Bridge is closed to traffic.'},
  {active: true, code: '0', name:	'Failed, closed', description:	'Bridge is scour critical. Bridge has failed and is closed to traffic.'}
]

replace_tables = %w{ operational_status_types route_signing_prefixes structure_material_types design_construction_types bridge_condition_rating_types channel_condition_types bridge_appraisal_rating_types strahnet_designation_types deck_structure_types  wearing_surface_types membrane_types deck_protection_types scour_critical_bridge_types
  }

replace_tables.each do |table_name|
  puts "  Loading #{table_name}"
  if is_mysql
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE #{table_name};")
  elsif is_sqlite
    ActiveRecord::Base.connection.execute("DELETE FROM #{table_name};")
  else
    ActiveRecord::Base.connection.execute("TRUNCATE #{table_name} RESTART IDENTITY;")
  end
  data = eval(table_name)
  klass = table_name.classify.constantize
  data.each do |row|
    x = klass.new(row.except(:belongs_to, :type))
    if row[:belongs_to] && (x.respond_to? row[:belongs_to])
      x.send("#{row[:belongs_to]}=", row[:belongs_to].classify.constantize.find_by(name: row[:type]))
    end
    x.save!
  end
end

merge_tables = %w{ organization_types asset_types asset_subtypes system_config_extensions }

merge_tables.each do |table_name|
  puts "  Merging #{table_name}"
  data = eval(table_name)
  klass = table_name.classify.constantize
  data.each do |row|
    x = klass.new(row.except(:belongs_to, :type))
    if row[:belongs_to] && (x.respond_to? row[:belongs_to])
      x.send("#{row[:belongs_to]}=", row[:belongs_to].classify.constantize.find_by(name: row[:type]))
    end
    x.save!
  end
end