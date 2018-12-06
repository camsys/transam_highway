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
    {active: true, code: 'B',	name: 'Posting Recommended	Open', description: 'posting recommended but not legally implemented (all signs not in place or not correctly implemented)'},
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
  {active: true, code: '01', name:	'Slab'},
  {active: true, code: '02', name:	'Stringer/Multi-beam or Girder'},
  {active: true, code: '03', name:	'Girder and Floorbeam System'},
  {active: true, code: '04', name:	'Tee Beam'},
  {active: true, code: '05', name:	'Box Beam or Girders - Multiple'},
  {active: true, code: '06', name:	'Box Beam or Girders - Single or Spread'},
  {active: true, code: '07', name:	'Frame (except frame culverts)'},
  {active: true, code: '08', name:	'Orthotropic'},
  {active: true, code: '09', name:	'Truss - Deck'},
  {active: true, code: '10', name:	'Truss - Thru'},
  {active: true, code: '11', name:	'Arch - Deck'},
  {active: true, code: '12', name:	'Arch - Thru'},
  {active: true, code: '13', name:	'Suspension'},
  {active: true, code: '14', name:	'Stayed Girder'},
  {active: true, code: '15', name:	'Movable - Lift'},
  {active: true, code: '16', name:	'Movable - Bascule'},
  {active: true, code: '17', name:	'Movable - Swing'},
  {active: true, code: '18', name:	'Tunnel'},
  {active: true, code: '19', name:	'Culvert (includes frame culverts)'},
  {active: true, code: '20', name:	'Mixed types'},
  {active: true, code: '22', name:	'Channel Beam'},
  {active: true, code: '00', name:	'Other'}
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


replace_tables = %w{ operational_status_types route_signing_prefixes structure_material_types design_construction_types bridge_condition_rating_types channel_condition_types
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
    x = klass.new(row)
    x.save!
  end
end

merge_tables = %w{ organization_types }

merge_tables.each do |table_name|
  puts "  Merging #{table_name}"
  data = eval(table_name)
  klass = table_name.classify.constantize
  data.each do |row|
    x = klass.new(row.except(:belongs_to, :type))
    x.save!
  end
end