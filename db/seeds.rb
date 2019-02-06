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
    {class_name: 'HighwayStructure', extension_name: 'TransamCoordinateLocatable', active: true},
    {class_name: 'AssetMapSearcher', extension_name: 'HighwayAssetMapSearchable', active: true}
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

structure_status_types = [
  {active: true, code: '0', name: 'Unknown'},
  {active: true, code: '1', name: 'Inactive'},
  {active: true, code: '2', name: 'Closed'},
  {active: true, code: '3', name: 'Active'},
  {active: true, code: '4', name: 'Proposed'},
  {active: true, code: '5', name: 'Obsolete'}
]

element_materials = [
    {code: '_', name:	'Missing', active: true},
    {code: '0',	name: 'Unspecified', active: true},
    {code: '1',	name: 'Unpainted Steel', active: true},
    {code: '2',	name: 'Painted Steel', active: true},
    {code: '3',	name: 'Prestressed Concrete', active: true},
    {code: '4',	name: 'Reinforced Concrete', active: true},
    {code: '5',	name: 'Timber', active: true},
    {code: '6',	name: 'Other', active: true},
    {code: '7',	name: 'Decks', active: true},
    {code: '8',	name: 'Slabs', active: true},
    {code: '9',	name: 'Smart Flags', active: true}
]

element_classifications = [
    {name: 'NBE', active: true}, {name: 'MBE', active: true}, {name: 'ADE', active: true}, {name: 'None', active: true}
]

defect_definitions = [
{number: 1000, short_name: 'Corrosion', long_name: 'Corrosion', description: 'This defect is used to report corrosion of metal and other material elements.'},
{number: 1010, short_name: 'Cracking', long_name: 'Cracking', description: 'This defect is used to report fatigue cracking in metal and other material elements.'},
{number: 1020, short_name: 'Connection', long_name: 'Connection', description: 'This defect is used to report connection distress in metal and other material elements.'},
{number: 1080, short_name: 'Delamination/Spall/Patched Area', long_name: 'Delamination/Spall/Patched Area', description: 'This defect is used to report spalls, delamination and patched areas in concrete, masonry and other material elements.'},
{number: 1090, short_name: 'Exposed Rebar', long_name: 'Exposed Rebar', description: 'This defect is used to report exposed conventional rein-forcing steel in reinforced and prestressed concrete ele-ments.'},
{number: 1100, short_name: 'Exposed Prestressing', long_name: 'Exposed Prestressing', description: 'This defect is used to report exposed prestressing steel in concrete elements.'},
{number: 1110, short_name: 'Cracking (PSC)', long_name: 'Cracking (PSC)', description: 'This defect is used to report cracking in prestressed con-crete elements.'},
{number: 1120, short_name: 'Efflorescence/Rust Staining', long_name: 'Efflorescence/Rust Staining', description: 'This defect is used to report efflorescence/rust staining in concrete and masonry elements.'},
{number: 1130, short_name: 'Cracking (RC and Other)', long_name: 'Cracking (RC and Other)', description: 'This defect is used to report cracking in reinforced con-crete and other material elements.'},
{number: 1140, short_name: 'Decay/Section Loss', long_name: 'Decay/Section Loss', description: 'This defect is used to report decay (section loss) in tim-ber elements.'},
{number: 1150, short_name: 'Check/Shake', long_name: 'Check/Shake', description: 'This defect is used to report checks and shakes in timber elements.'},
{number: 1160, short_name: 'Crack (Timber)', long_name: 'Crack (Timber)', description: 'This defect is used to report cracking in timber elements.'},
{number: 1170, short_name: 'Split/Delamination (Timber)', long_name: 'Split/Delamination (Timber)', description: 'This defect is used to report splits/delaminations in tim-ber elements.'},
{number: 1180, short_name: 'Abrasion', long_name: 'Abrasion/Wear (Timber)', description: 'This defect is used to report abrasion in timber elements.'},
{number: 1190, short_name: 'Abrasion(PSC/RC)', long_name: 'Abrasion/Wear(PSC/RC)', description: 'This defect is used to report abrasion in concrete elements.'},
{number: 1220, short_name: 'Deterioration (Other)', long_name: 'Deterioration (Other)', description: 'This defect is used to report general deterioration in elements constructed of other materials such as fiber reinforced plastics or similar.'},
{number: 1610, short_name: 'Mortar Breakdown (Masonry)', long_name: 'Mortar Breakdown (Masonry)', description: 'This defect is used to report breakdown of masonry mortar between brick, block or stone.'},
{number: 1620, short_name: 'Split/Spall (Masonry)', long_name: 'Split/Spall (Masonry)', description: 'This defect is used to report splits or spalls in brick, block or stone.'},
{number: 1630, short_name: 'Patched Area (Masonry)', long_name: 'Patched Area (Masonry)', description: 'This defect is used to report masonry patched areas.'},
{number: 1640, short_name: 'Masonry Displacement', long_name: 'Masonry Displacement', description: 'This defect is used to report displaced brick, block or stone.'},
{number: 1900, short_name: 'Distortion', long_name: 'Distortion', description: 'This defect is used to report distortion from the original line or grade of the element. It is used to capture all distortion regardless of cause.'},
{number: 2210, short_name: 'Movement', long_name: 'Movement', description: 'This defect is used to report movement of bridge bearing elements.'},
{number: 2220, short_name: 'Alignment', long_name: 'Alignment', description: 'This defect is used to report alignment of bridge bearing elements.'},
{number: 2230, short_name: 'Bulging', long_name: ' Splitting or Tearing', description: 'Bulging, Splitting or Tearing,This defect is used to report bulging, splitting or tearing of elastomeric bearing elements.'},
{number: 2240, short_name: 'Loss of Bearing Area', long_name: 'Loss of Bearing Area', description: 'This defect is used to report the loss of bearing area for bridge bearing elements.'},
{number: 2310, short_name: 'Leakage', long_name: 'Leakage', description: 'This defect is used to report leakage through or around sealed bridge joints.'},
{number: 2320, short_name: 'Seal Adhesion', long_name: 'Seal Adhesion', description: 'This defect is used to report loss of adhesion in sealed bridge joints.'},
{number: 2330, short_name: 'Seal Damage', long_name: 'Seal Damage', description: 'This defect is used to report damage to the rubber in bridge joint seals.'},
{number: 2340, short_name: 'Seal Cracking', long_name: 'Seal Cracking', description: 'This defect is used to report cracking in the rubber in bridge joint seals.'},
{number: 2350, short_name: 'Debris Impaction', long_name: 'Debris Impaction', description: 'This defect is used to report the accumulation of debris in bridge joint seals that may or may not affect the per-formance of the joints.'},
{number: 2360, short_name: 'Adjacent Deck or Header', long_name: 'Adjacent Deck or Header', description: 'This defect is used to report concrete deck damage in the area anchoring the bridge joint.'},
{number: 2370, short_name: 'Metal Deterioration or Damage', long_name: 'Metal Deterioration or Damage', description: 'This defect is used to report metal damage or deteriora-tion in the bridge joint.'},
{number: 3210, short_name: 'Del/Spall/Patch/Pot(Wear Surf)', long_name: 'Delamination/Spall/Patched Area/Pothole (Wearing Surfaces)', description: 'This defect is used to report spalls, delaminations, patched areas and potholes in wearing surface elements.'},
{number: 3220, short_name: 'Crack (Wearing Surface)', long_name: 'Crack (Wearing Surface)', description: 'This defect is used to report cracking in wearing surface elements.'},
{number: 3230, short_name: 'Effectiveness (Wearing Surface)', long_name: 'Effectiveness (Wearing Surface)', description: 'This defect is used to the loss of effectiveness in the protection provided to the deck by the wearing surface elements.'},
{number: 3410, short_name: 'Chalk(Steel Protect Coatings)', long_name: 'Chalking (Steel Protective Coatings)', description: 'This defect is used to report chalking in metal protective coatings.'},
{number: 3420, short_name: 'Peel/Bub/Crack(Stl Protect Coat)', long_name: 'Peeling/Bubbling/Cracking (Steel Protective Coatings)', description: 'This defect is used to report peeling, bubbling or crack-ing in metal protective coatings.'},
{number: 3430, short_name: 'Ox Flm/Txt Adhr(Stl Prot Coat)', long_name: 'Oxide Film Degradation Color/Texture Adherence(Stl Protect Coat)', description: 'This defect is used to report oxide film degradation of texture in metal protective coatings.'},
{number: 3440, short_name: 'Eff (Stl Protect Coat)', long_name: 'Effectiveness (Steel Protective Coatings)', description: 'This defect is used to report the loss of effectiveness of metal protective coatings.'},
{number: 3510, short_name: 'Wear (Concrete Protect Coat)', long_name: 'Wear (Concrete Protective Coatings)', description: 'This defect is used to report the wearing of concrete protective coatings.'},
{number: 3540, short_name: 'Eff(Crete Protect Coat)', long_name: 'Effectiveness (Concrete Protective Coatings)', description: 'This defect is used to report the effectiveness of concrete protective coatings.'},
{number: 3600, short_name: 'Eff - Protect Sys(e.g. cathodic)', long_name: 'Effectiveness - Protective System (e.g. cathodic)', description: 'This defect is used to report the effectiveness of internal concrete protective systems (epoxy rebar, cathodic pro-tection etc.).'},
{number: 4000, short_name: 'Settlement', long_name: 'Settlement', description: 'This defect is used to report settlement in substructure elements.'},
{number: 6000, short_name: 'Scour', long_name: 'Scour', description: 'This defect is used to report scour in substructure elements.'},
{number: 7000, short_name: 'Damage', long_name: 'Damage', description: 'This defect is used to capture impact damage that has occurred.'}
]

inspection_types = [
    {code: '1', name: 'Regular NBI inspection', active: true},
    {code: '4', name: 'Special', active: true},
    {code: 'D', name: 'Underwater - Contract SCUBA', active: true},
    {code: 'L', name: 'Special - Accident Damage (traffic)', active: true},
    {code: 'M', name: 'Special - Natural Disaster Damage', description: 'Special - Natural Disaster Damage (flood, fire, wind, earthquake, etc.)', active: true},
    {code: 'O', name: 'Special - Other', active: true}
]

merge_tables = %w{ organization_types asset_types asset_subtypes system_config_extensions }

merge_tables.each do |table_name|
  puts "  Merging #{table_name}"
  data = eval(table_name)
  klass = table_name.classify.constantize
  data.each do |row|
    x = klass.find_or_initialize_by(row.except(:belongs_to, :type))
    if row[:belongs_to] && (x.respond_to? row[:belongs_to])
      x.send("#{row[:belongs_to]}=", row[:belongs_to].classify.constantize.find_by(name: row[:type]))
    end
    x.save!
  end
end

replace_tables = %w{ operational_status_types route_signing_prefixes structure_material_types design_construction_types bridge_condition_rating_types channel_condition_types bridge_appraisal_rating_types strahnet_designation_types deck_structure_types  wearing_surface_types membrane_types deck_protection_types scour_critical_bridge_types structure_status_types element_materials element_classifications defect_definitions inspection_types
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