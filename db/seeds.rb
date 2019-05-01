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
    },
    {name: "Highway Consultant",
     class_name: "HighwayConsultant",
     display_icon_name: "fa fa-user-circle",
     map_icon_name: "purpleIcon",
     description: "Consultant on highway structures, bridges.",
     roles: nil,
     active: true}
]
asset_types = [
    {name: 'Bridge', description: 'Bridge', class_name: 'Bridge', display_icon_name: 'fa fa-road', map_icon_name: 'blueIcon', active: true},
    {name: 'Culvert', description: 'Culvert', class_name: 'Culvert', display_icon_name: 'fa fa-road', map_icon_name: 'blueIcon', active: true}

]
asset_subtypes = [
  {belongs_to: 'asset_type', type: 'Bridge', name: 'Arch', description: 'Arched Bridge', active: true},
  {belongs_to: 'asset_type', type: 'Bridge', name: 'Beam', description: 'Beam Bridge', active: true},
  {belongs_to: 'asset_type', type: 'Bridge', name: 'Slab', description: 'Slab Bridge', active: true},
  {belongs_to: 'asset_type', type: 'Bridge', name: 'Suspension', description: 'Suspension Bridge', active: true},
  {belongs_to: 'asset_type', type: 'Bridge', name: 'Truss', description: 'Truss Bridge', active: true},
  {belongs_to: 'asset_type', type: 'Bridge', name: 'Other', description: 'Other Bridge', active: true},
  {belongs_to: 'asset_type', type: 'Culvert', name: 'Culvert', description: 'Culvert', active: true}
]

roles = [
    {name: 'inspector', show_in_user_mgmt: true, privilege: false, weight: 5}
]

system_config_extensions = [
    {class_name: 'HighwayStructure', extension_name: 'TransamCoordinateLocatable', engine_name: 'highway', active: true},
    {class_name: 'AssetMapSearcher', extension_name: 'HighwayAssetMapSearchable', engine_name: 'highway', active: true},
    {class_name: 'TransamAsset', extension_name: 'TransamGuid', engine_name: 'highway', active: true},
    {class_name: 'TransamAsset', extension_name: 'TransamGuid', engine_name: 'highway', active: true},
    {class_name: 'Inspection', extension_name: 'TransamGuid', engine_name: 'highway', active: true},
    {class_name: 'Element', extension_name: 'TransamGuid', engine_name: 'highway', active: true},
    {class_name: 'Defect', extension_name: 'TransamGuid', engine_name: 'highway', active: true},
    {class_name: 'Image', extension_name: 'TransamGuid', engine_name: 'highway', active: true},
    {class_name: 'Document', extension_name: 'TransamGuid', engine_name: 'highway', active: true},
    {class_name: 'Roadway', extension_name: 'TransamGuid', engine_name: 'highway', active: true},
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
  {active: true, code: '19', name:	'Culvert (includes frame culverts)', belongs_to: 'asset_subtype', type: 'Culvert'},
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

culvert_condition_types = [
    {active: true, code: 'N', name: 'Not applicable', description: 'Used if structure is not a culvert.'},
    {active: true, code: '9', name: 'Excellent', description: 'No deficiencies.'},
    {active: true, code: '8', name: 'Very good', description: 'No noticeable or noteworthy deficiencies which affect the condition of the culvert. Insignificant scrape marks caused by drift.'},
    {active: true, code: '7', name: 'Good', description: 'Shrinkage cracks, light scaling and insignificant spalling which does not expose reinforcing steel. Insignificant damage caused by drift with no misalignment and not requiring corrective action. Some minor scouring has occurred near curtain walls, wingwalls or pipes. Metal culverts have a smooth symmetrical curvature with superficial corrosion and no pitting.'},
    {active: true, code: '6', name: 'Satisfactory', description: 'Deterioration or initial disintegration, minor chloride contamination, cracking with some leaching, or spalls on concrete or masonry walls and slabs. Local minor scouring at curtain walls, wingwalls or pipes. Metal culverts have a smooth curvature, non-symmetrical shape, significant corrosion or moderate pitting.'},
    {active: true, code: '5', name: 'Fair', description: 'Moderate to major deterioration or disintegration, extensive cracking and leaching or spalls on concrete or masonry walls and slabs. Minor settlement or misalignment. Noticeable scouring or erosion at curtain walls, wingwalls or pipes. Metal culverts have significant distortion and deflection in one section, significant corrosion or deep pitting.'},
    {active: true, code: '4', name: 'Poor', description: 'Large spalls, heavy scaling, wide cracks, considerable efflorescence or opened construction joint permitting loss of backfill. Considerable settlement or misalignment. Considerable scouring or erosion at curtain walls, wingwalls or pipes. Metal culverts have significant distortion and deflection throughout, extensive corrosion or deep pitting.'},
    {active: true, code: '3', name: 'Serious', description: 'Any condition described in Code 4 but which is excessive in scope. Severe movement or differential settlement of the segments or loss of fill. Holes may exist in walls or slabs. Integral wingwalls nearly severed from culvert. Severe scour or erosion at curtain walls, wingwalls or pipes. Metal culverts have extreme distortion and deflection in one
    section, extensive corrosion, or deep pitting with scattered perforations.'},
    {active: true, code: '2', name: 'Critical', description: 'Integral wingwalls collapsed, severe settlement of roadway due to loss of fill. Section of culvert may have failed and can no longer support embankment. Complete undermining at curtain walls and pipes. Corrective action required to maintain traffic. Metal culverts have extreme distortion and deflection and deflection throughout with extensive perforations due to corrosion.'},
    {active: true, code: '1', name: 'Imminent failure', description: 'Bridge closed. Corrective action may put back in light service.'},
    {active: true, code: '0', name: 'Failed', description: 'Bridge closed. Replacement necessary.'}

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

structure_agent_types = [
  {code: '01', name: 'State Highway Agency', active: true},
  {code: '02', name: 'County Highway Agency', active: true},
  {code: '03', name: 'Town or Township Highway Agency', active: true},
  {code: '04', name: 'City or Municipal Highway Agency', active: true},
  {code: '11', name: 'State Park, Forest, or Reservation Agency', active: true},
  {code: '12', name: 'Local Park, Forest, or Reservation Agency', active: true},
  {code: '21', name: 'Other State Agencies', active: true},
  {code: '25', name: 'Other Local Agencies', active: true},
  {code: '26', name: 'Private (other than railroad)', active: true},
  {code: '27', name: 'Railroad', active: true},
  {code: '31', name: 'State Toll Authority', active: true},
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
    {code: '9',	name: 'Smart Flags', active: false}
]

element_classifications = [
    {name: 'NBE', active: true}, {name: 'BME', active: true}, {name: 'ADE', active: true}, {name: 'None', active: true}
]

assembly_types = [
    {name: 'Deck', active: true}, {name: 'Superstructure', active: true}, 
    {name: 'Substructure', active: true}, {name: 'Joints', active: true}, 
    {name: 'Rails', active: true}, {name: 'Other', active: true}
]

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

service_level_types = [
    {active: true, code: '0',	name: 'Other'},
    {active: true, code: '1',	name: 'Mainline'},
    {active: true, code: '2',	name: 'Alternate'},
    {active: true, code: '3',   name: 'Bypass'},
    {active: true, code: '4',	name: 'Spur'},
    {active: true, code: '6',	name: 'Business'},
    {active: true, code: '7',	name: 'Ramp/Wye/Connector'},
    {active: true, code: '8',	name: 'Service/Frontage Road'}
]

functional_classes = [
    {active: true, code: '01',	name: 'Rural Principal Arterial - Interstate'},
    {active: true, code: '02',	name: 'Rural Principal Arterial - Other'},
    {active: true, code: '06',	name: 'Rural Minor Arterial'},
    {active: true, code: '07',	name: 'Rural Major Collector'},
    {active: true, code: '08',	name: 'Rural Minor Collector'},
    {active: true, code: '09',	name: 'Rural Local'},
    {active: true, code: '11',	name: 'Urban Principal Arterial - Interstate'},
    {active: true, code: '12',	name: 'Urban Principal Arterial - Other Freeways or Expressways'},
    {active: true, code: '14',	name: 'Urban Other Principal Arterial'},
    {active: true, code: '16',	name: 'Urban Minor Arterial'},
    {active: true, code: '17',	name: 'Urban Collector'},
    {active: true, code: '19',	name: 'Urban Local'}
]

traffic_direction_types = [
    {active: true, code: '0',	name: 'Highway traffic not carried'},
    {active: true, code: '1',	name: '1-way traffic'},
    {active: true, code: '2',	name: '2-way traffic'},
    {active: true, code: '3',	name: 'One lane bridge for 2-way traffic'}
]

defect_definitions = [
{number: 1000, short_name: 'Corrosion', long_name: 'Corrosion', description: 'This defect is used to report corrosion of metal and other material elements.'},
{number: 1010, short_name: 'Cracking', long_name: 'Cracking', description: 'This defect is used to report fatigue cracking in metal and other material elements.'},
{number: 1020, short_name: 'Connection', long_name: 'Connection', description: 'This defect is used to report connection distress in metal and other material elements.'},
{number: 1080, short_name: 'Delamination/Spall/Patched Area', long_name: 'Delamination/Spall/Patched Area', description: 'This defect is used to report spalls, delamination and patched areas in concrete, masonry and other material elements.'},
{number: 1090, short_name: 'Exposed Rebar', long_name: 'Exposed Rebar', description: 'This defect is used to report exposed conventional reinforcing steel in reinforced and prestressed concrete elements.'},
{number: 1100, short_name: 'Exposed Prestressing', long_name: 'Exposed Prestressing', description: 'This defect is used to report exposed prestressing steel in concrete elements.'},
{number: 1110, short_name: 'Cracking (PSC)', long_name: 'Cracking (PSC)', description: 'This defect is used to report cracking in prestressed concrete elements.'},
{number: 1120, short_name: 'Efflorescence/Rust Staining', long_name: 'Efflorescence/Rust Staining', description: 'This defect is used to report efflorescence/rust staining in concrete and masonry elements.'},
{number: 1130, short_name: 'Cracking (RC and Other)', long_name: 'Cracking (RC and Other)', description: 'This defect is used to report cracking in reinforced concrete and other material elements.'},
{number: 1140, short_name: 'Decay/Section Loss', long_name: 'Decay/Section Loss', description: 'This defect is used to report decay (section loss) in timber elements.'},
{number: 1150, short_name: 'Check/Shake', long_name: 'Check/Shake', description: 'This defect is used to report checks and shakes in timber elements.'},
{number: 1160, short_name: 'Crack (Timber)', long_name: 'Crack (Timber)', description: 'This defect is used to report cracking in timber elements.'},
{number: 1170, short_name: 'Split/Delamination (Timber)', long_name: 'Split/Delamination (Timber)', description: 'This defect is used to report splits/delaminations in timber elements.'},
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
{number: 2350, short_name: 'Debris Impaction', long_name: 'Debris Impaction', description: 'This defect is used to report the accumulation of debris in bridge joint seals that may or may not affect the performance of the joints.'},
{number: 2360, short_name: 'Adjacent Deck or Header', long_name: 'Adjacent Deck or Header', description: 'This defect is used to report concrete deck damage in the area anchoring the bridge joint.'},
{number: 2370, short_name: 'Metal Deterioration or Damage', long_name: 'Metal Deterioration or Damage', description: 'This defect is used to report metal damage or deterioration in the bridge joint.'},
{number: 3210, short_name: 'Del/Spall/Patch/Pot(Wear Surf)', long_name: 'Delamination/Spall/Patched Area/Pothole (Wearing Surfaces)', description: 'This defect is used to report spalls, delaminations, patched areas and potholes in wearing surface elements.'},
{number: 3220, short_name: 'Crack (Wearing Surface)', long_name: 'Crack (Wearing Surface)', description: 'This defect is used to report cracking in wearing surface elements.'},
{number: 3230, short_name: 'Effectiveness (Wearing Surface)', long_name: 'Effectiveness (Wearing Surface)', description: 'This defect is used to the loss of effectiveness in the protection provided to the deck by the wearing surface elements.'},
{number: 3410, short_name: 'Chalk(Steel Protect Coatings)', long_name: 'Chalking (Steel Protective Coatings)', description: 'This defect is used to report chalking in metal protective coatings.'},
{number: 3420, short_name: 'Peel/Bub/Crack(Stl Protect Coat)', long_name: 'Peeling/Bubbling/Cracking (Steel Protective Coatings)', description: 'This defect is used to report peeling, bubbling or cracking in metal protective coatings.'},
{number: 3430, short_name: 'Ox Flm/Txt Adhr(Stl Prot Coat)', long_name: 'Oxide Film Degradation Color/Texture Adherence(Stl Protect Coat)', description: 'This defect is used to report oxide film degradation of texture in metal protective coatings.'},
{number: 3440, short_name: 'Eff (Stl Protect Coat)', long_name: 'Effectiveness (Steel Protective Coatings)', description: 'This defect is used to report the loss of effectiveness of metal protective coatings.'},
{number: 3510, short_name: 'Wear (Concrete Protect Coat)', long_name: 'Wear (Concrete Protective Coatings)', description: 'This defect is used to report the wearing of concrete protective coatings.'},
{number: 3540, short_name: 'Eff(Crete Protect Coat)', long_name: 'Effectiveness (Concrete Protective Coatings)', description: 'This defect is used to report the effectiveness of concrete protective coatings.'},
{number: 3600, short_name: 'Eff - Protect Sys(e.g. cathodic)', long_name: 'Effectiveness - Protective System (e.g. cathodic)', description: 'This defect is used to report the effectiveness of internal concrete protective systems (epoxy rebar, cathodic protection etc.).'},
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

feature_safety_types = [
    {code: '0', name:	'Not acceptable', description:	'Inspected feature does not meet currently acceptable stds. or a safety feature is required and none is provided.', active: true},
    {code: '1', name:	'Acceptable',	description: 'Inpected feature meets currently acceptable standards.', active: true},
    {code: 'N', name:'Not applicable', description:	'Not applicable or a safety feature is not required.', active: true}
]

element_definitions = [
{number: 12, is_nbe: 'Y', is_protective: 'N', cat_key: '6', type_key: '06', mat_key: '7', short_name: 'Re Concrete Deck', long_name: 'Reinforced Concrete Deck', quantity_unit: 'sq feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines all reinforced concrete bridge deck/slab regardless of the wearing surface or protection systems used.'},
{number: 13, is_nbe: 'Y', is_protective: 'N', cat_key: '6', type_key: '06', mat_key: '7', short_name: 'Pre Concrete Deck', long_name: 'Prestressed Concrete Deck', quantity_unit: 'sq feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines all prestressed concrete bridge decks regardless of the wearing surface or protection systems used.'},
{number: 15, is_nbe: 'Y', is_protective: 'N', cat_key: '6', type_key: '06', mat_key: '7', short_name: 'Pre Concrete Top Flange', long_name: 'Prestressed Concrete Top Flange', quantity_unit: 'sq feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines those bridge girder top flanges that are exposed to traffic. This element defines all prestressed and reinforced concrete bridge girder top flanges regardless of the wearing surface or protection systems used. These bridge types include tee-beams, bulb-tees, and girders that require traffic to ride on the top flange.'},
{number: 16, is_nbe: 'Y', is_protective: 'N', cat_key: '6', type_key: '06', mat_key: '7', short_name: 'Re Conc Top Flange', long_name: 'Reinforced Concrete Top Flange', quantity_unit: 'sq feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines all reinforced concrete bridge girder top flanges where traffic rides directly on the structural element regardless of the wearing surface or protection systems used. These bridge types include tee-beams, box girders, and girders that require traffic to ride on the top flange.'},
{number: 28, is_nbe: 'Y', is_protective: 'N', cat_key: '6', type_key: '06', mat_key: '7', short_name: 'Steel Deck - Open Grid', long_name: 'Steel Deck With Open Grid', quantity_unit: 'sq feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines all open grid steel bridge decks with no fill.'},
{number: 29, is_nbe: 'Y', is_protective: 'N', cat_key: '6', type_key: '06', mat_key: '7', short_name: 'Steel Deck - Conc Fill Grid', long_name: 'Steel Deck with Concrete Filled Grid', quantity_unit: 'sq feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines steel bridge decks with concrete fill either in all of the openings or within the wheel tracks.'},
{number: 30, is_nbe: 'Y', is_protective: 'N', cat_key: '6', type_key: '06', mat_key: '7', short_name: 'Steel Deck - Orthotropic', long_name: 'Steel Deck Corrugated/Orthotropic/Etc.', quantity_unit: 'sq feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines those bridge decks constructed of corrugated metal filled with Portland cement, asphaltic concrete or other riding surfaces. Orthotropic steel decks are also included.'},
{number: 31, is_nbe: 'Y', is_protective: 'N', cat_key: '6', type_key: '06', mat_key: '7', short_name: 'Timber Deck', long_name: 'Timber Deck', quantity_unit: 'sq feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines all timber bridge deck/slab regardless of the wearing surface or protection systems used.'},
{number: 38, is_nbe: 'Y', is_protective: 'N', cat_key: '6', type_key: '06', mat_key: '7', short_name: 'Re Concrete Slab', long_name: 'Reinforced Concrete Slab', quantity_unit: 'sq feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines all reinforced concrete bridge deck/slab regardless of the wearing surface or protection systems used.'},
{number: 39, is_nbe: 'Y', is_protective: 'N', cat_key: '6', type_key: '06', mat_key: '3', short_name: 'PSC Slab', long_name: 'Prestressed Concrete Slab', quantity_unit: '', created_at: '2015-02-24 14:59:15.643000000', updated_at: '2015-02-24 14:59:15.643000000', description: ''},
{number: 54, is_nbe: 'Y', is_protective: 'N', cat_key: '6', type_key: '06', mat_key: '8', short_name: 'Timber Slab', long_name: 'Timber Slab', quantity_unit: 'sq feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines all timber bridge deck/slab regardless of the wearing surface or protection systems used.'},
{number: 60, is_nbe: 'Y', is_protective: 'N', cat_key: '6', type_key: '06', mat_key: '8', short_name: 'Other Deck', long_name: 'Other Deck', quantity_unit: 'sq feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines all bridge decks constructed of other materials regardless of the wearing surface or protection systems used.'},
{number: 65, is_nbe: 'Y', is_protective: 'N', cat_key: '6', type_key: '06', mat_key: '8', short_name: 'Other Slab', long_name: 'Other Slab', quantity_unit: 'sq feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines all slabs constructed of other materials regardless of the wearing surface or protection systems used.'},
{number: 102, is_nbe: 'Y', is_protective: 'N', cat_key: '1', type_key: '12', mat_key: '1', short_name: 'Steel Clsd Box Gird', long_name: 'Steel Closed Web/Box Girder', quantity_unit: 'feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines all steel box girders or closed web girders. This element is for all box girders regardless of protective system.'},
{number: 104, is_nbe: 'Y', is_protective: 'N', cat_key: '1', type_key: '12', mat_key: '3', short_name: 'Pre Clsd Box Girder', long_name: 'Prestressed Concrete Closed Web/Box Girder', quantity_unit: 'feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines pre-tensioned or post tensioned concrete closed web girder or box girder. This element is for all box girders regardless of protective system.'},
{number: 105, is_nbe: 'Y', is_protective: 'N', cat_key: '1', type_key: '12', mat_key: '4', short_name: 'Re Clsd Box Girder', long_name: 'Reinforced Concrete Closed Web/Box Girder', quantity_unit: 'feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines a reinforced concrete box girder or closed web girder. This element is for all box girders regardless of the protective system'},
{number: 106, is_nbe: 'Y', is_protective: 'N', cat_key: '1', type_key: '12', mat_key: '4', short_name: 'Othr Clsd Web/Box Girder', long_name: 'Other Closed Web/Box Girder', quantity_unit: 'feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines all other material box girders or closed web girders, and is for all other material box girders regardless of protective system.'},
{number: 107, is_nbe: 'Y', is_protective: 'N', cat_key: '1', type_key: '12', mat_key: '1', short_name: 'Steel Opn Girder/Beam', long_name: 'Steel Open Girder/Beam', quantity_unit: 'feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines all steel open girders. This element is for all girders regardless of protective system.'},
{number: 109, is_nbe: 'Y', is_protective: 'N', cat_key: '1', type_key: '12', mat_key: '3', short_name: 'Pre Opn Conc Girder/Beam', long_name: 'Prestressed Concrete Open Girder/Beam', quantity_unit: 'feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines pre-tensioned or post tensioned concrete open web girders. This element is for all girders regardless of protective system.'},
{number: 110, is_nbe: 'Y', is_protective: 'N', cat_key: '1', type_key: '12', mat_key: '4', short_name: 'Re Conc Opn Girder/Beam', long_name: 'Reinforced Concrete Open Girder/Beam', quantity_unit: 'feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines pre-tensioned or post tensioned concrete open web girders. This element is for all girders regardless of protective system.'},
{number: 111, is_nbe: 'Y', is_protective: 'N', cat_key: '1', type_key: '12', mat_key: '5', short_name: 'Timber Open Girder', long_name: 'Timber Open Girder/Beam', quantity_unit: 'feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines all timber girders. This element is for all girders regardless of protection system.'},
{number: 112, is_nbe: 'Y', is_protective: 'N', cat_key: '1', type_key: '12', mat_key: '5', short_name: 'Other Open Girder/Beam', long_name: 'Other Open Girder/Beam', quantity_unit: 'feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines all other material girders, and is for all girders regardless of protection system.'},
{number: 113, is_nbe: 'Y', is_protective: 'N', cat_key: '1', type_key: '12', mat_key: '1', short_name: 'Steel Stringer', long_name: 'Steel Stringer', quantity_unit: 'feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines steel members that support the deck in a stringer floor beam system. This element is for all stringers regardless of protective system.'},
{number: 115, is_nbe: 'Y', is_protective: 'N', cat_key: '1', type_key: '12', mat_key: '3', short_name: 'Pre Conc Stringer', long_name: 'Prestressed Concrete Stringer', quantity_unit: 'feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines pre-tensioned or post tensioned concrete members that support the deck in a stringer floor beam system. This element is for all stringers regardless of protective system.'},
{number: 116, is_nbe: 'Y', is_protective: 'N', cat_key: '1', type_key: '12', mat_key: '4', short_name: 'Re Conc Stringer', long_name: 'Reinforced Concrete Stringer', quantity_unit: 'feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines mild steel reinforced concrete members that support the deck in a stringer floor beam system. This element is for all stringers regardless of protective system.'},
{number: 117, is_nbe: 'Y', is_protective: 'N', cat_key: '1', type_key: '12', mat_key: '5', short_name: 'Timber Stringer', long_name: 'Timber Stringer', quantity_unit: 'feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines timber members that support the deck in a stringer floor beam system. This element is for all stringers regardless of protective system.'},
{number: 118, is_nbe: 'Y', is_protective: 'N', cat_key: '1', type_key: '12', mat_key: '5', short_name: 'Other Stringer', long_name: 'Other Stringer', quantity_unit: 'feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines all other material stringers, and is for all stringers regardless of protection system.'},
{number: 120, is_nbe: 'Y', is_protective: 'N', cat_key: '1', type_key: '14', mat_key: '1', short_name: 'Steel Tuss', long_name: 'Steel Truss', quantity_unit: 'feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines all steel truss elements. This includes all tension and compression members. This element includes through and deck trusses. This element is for all trusses regardless of protective system.'},
{number: 135, is_nbe: 'Y', is_protective: 'N', cat_key: '1', type_key: '14', mat_key: '5', short_name: 'Timber Truss', long_name: 'Timber Truss', quantity_unit: 'feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines all timber truss element. This includes all tension and compression members. This element includes through and deck trusses. This element is for all trusses regardless of protective system.'},
{number: 136, is_nbe: 'Y', is_protective: 'N', cat_key: '1', type_key: '14', mat_key: '5', short_name: 'Other Truss', long_name: 'Other Truss', quantity_unit: 'feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines all other material truss elements, including all tension and compression members, and through and deck trusses. It is for all other material trusses regardless of protective system.'},
{number: 141, is_nbe: 'Y', is_protective: 'N', cat_key: '1', type_key: '15', mat_key: '2', short_name: 'Stl Arch', long_name: 'Steel Arch', quantity_unit: 'feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines steel arches regardless of type. This element is for all arches regardless of protective system.'},
{number: 142, is_nbe: 'Y', is_protective: 'N', cat_key: '1', type_key: '12', mat_key: '2', short_name: 'Other Arch', long_name: 'Other Arch', quantity_unit: 'feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines other material arches regardless of type, and is for all other material arches regardless of protective system.'},
{number: 143, is_nbe: 'Y', is_protective: 'N', cat_key: '1', type_key: '15', mat_key: '3', short_name: 'Pre Conc Arch', long_name: 'Prestressed Concrete Arch', quantity_unit: 'feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines only pre-tensioned or post tensioned concrete arches. This element is for all arches regardless of protective system.'},
{number: 144, is_nbe: 'Y', is_protective: 'N', cat_key: '1', type_key: '15', mat_key: '4', short_name: 'Re Conc Arch', long_name: 'Reinforced Concrete Arch', quantity_unit: 'feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines only mild steel reinforced concrete arches. This element is for all arches regardless of protective system.'},
{number: 145, is_nbe: 'Y', is_protective: 'N', cat_key: '1', type_key: '15', mat_key: '6', short_name: 'Masonry Arch', long_name: 'Masonry Arch', quantity_unit: 'feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines masonry or stacked stone arches. This element is for all arches regardless of protective system.'},
{number: 146, is_nbe: 'Y', is_protective: 'N', cat_key: '1', type_key: '15', mat_key: '6', short_name: 'Timber Arch', long_name: 'Timber Arch', quantity_unit: 'feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines only timber arches. This element is for all arches regardless of protective system.'},
{number: 147, is_nbe: 'Y', is_protective: 'N', cat_key: '1', type_key: '16', mat_key: '6', short_name: 'Stl Main Cables', long_name: 'Steel Main Cables', quantity_unit: 'feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines all steel main suspension or cable stay cables not embedded in concrete. This element is for all cable groups regardless of protective systems.'},
{number: 148, is_nbe: 'Y', is_protective: 'N', cat_key: '1', type_key: '12', mat_key: '1', short_name: 'Sec Steel Cables', long_name: 'Secondary Steel Cables', quantity_unit: 'each', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines all steel suspender cables or other secondary cables not embedded in concrete. This element is for all cable groups regardless of protective systems.'},
{number: 149, is_nbe: 'Y', is_protective: 'N', cat_key: '1', type_key: '12', mat_key: '1', short_name: 'Otr Secondary Cable', long_name: 'Other Secondary Cable', quantity_unit: 'each', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines all other material cables not embedded in concrete. It is for all individual other material cables or cable groups regardless of protective systems.'},
{number: 152, is_nbe: 'Y', is_protective: 'N', cat_key: '1', type_key: '12', mat_key: '1', short_name: 'Steel Floor Beam', long_name: 'Steel Floor Beam', quantity_unit: 'feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines only steel elements that support stringers. This element is for all floor beams regardless of protective system.'},
{number: 154, is_nbe: 'Y', is_protective: 'N', cat_key: '1', type_key: '12', mat_key: '3', short_name: 'Prestress Floor Beam', long_name: 'Prestressed Concrete Floor Beam', quantity_unit: 'feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines only prestressed elements that support stringers. This element is for all floor beams regardless of protective system.'},
{number: 155, is_nbe: 'Y', is_protective: 'N', cat_key: '1', type_key: '12', mat_key: '4', short_name: 'Re Conc Floor Beam', long_name: 'Reinforced Concrete Floor Beam', quantity_unit: 'feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines only mild steel reinforced concrete elements that support stringers. This element is for all floor beams regardless of protective system.'},
{number: 156, is_nbe: 'Y', is_protective: 'N', cat_key: '1', type_key: '12', mat_key: '5', short_name: 'Timber Floor Beam', long_name: 'Timber Floor Beam', quantity_unit: 'feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines only timber superstructure elements that support stringers. This element is for all floor beams regardless of protective system.'},
{number: 157, is_nbe: 'Y', is_protective: 'N', cat_key: '1', type_key: '12', mat_key: '5', short_name: 'Other Floor Beam', long_name: 'Other Floor Beam', quantity_unit: 'feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines other material floor beams that typically support stringers, and is for all floor beams regardless of protective system.'},
{number: 161, is_nbe: 'Y', is_protective: 'N', cat_key: '1', type_key: '13', mat_key: '2', short_name: 'Stl Pin Pin/Han both', long_name: 'Steel Pin and Pin & Hanger Assembly or both', quantity_unit: 'each', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines steel pin and hanger assemblies. This element is for all assemblies regardless of protective system.'},
{number: 162, is_nbe: 'Y', is_protective: 'N', cat_key: '1', type_key: '13', mat_key: '2', short_name: 'Stl Gus Plate', long_name: 'Steel Gusset Plate', quantity_unit: 'each', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This member defines only those steel gusset plate(s) connections that are on the main truss/arch panel(s). These connections can be constructed with one or more plates that may be bolted, riveted or welded. This element is for all gusset plates regardless of protective systems.'},
{number: 202, is_nbe: 'Y', is_protective: 'N', cat_key: '2', type_key: '21', mat_key: '1', short_name: 'Steel Column', long_name: 'Steel Column', quantity_unit: 'each', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines only those steel columns or pile extensions. Piles exposed from erosion or included as part of the diver inspection are not included in this element. This element is for all columns/pile extensions regardless of protective system.'},
{number: 203, is_nbe: 'Y', is_protective: 'N', cat_key: '2', type_key: '21', mat_key: '1', short_name: 'Other Column', long_name: 'Other Column', quantity_unit: 'each', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element is for all other material columns regardless of protective system.'},
{number: 204, is_nbe: 'Y', is_protective: 'N', cat_key: '2', type_key: '21', mat_key: '3', short_name: 'Pre Conc Column', long_name: 'Prestressed Concrete Column', quantity_unit: 'each', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines only those prestressed columns or pile extensions. Piles exposed from erosion or included as part of the diver inspection are not included in this element. This element is for all columns/pile extensions regardless of protective system.'},
{number: 205, is_nbe: 'Y', is_protective: 'N', cat_key: '2', type_key: '21', mat_key: '4', short_name: 'Re Conc Column', long_name: 'Reinforced Concrete Column', quantity_unit: 'each', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines only those reinforced columns or pile extensions. Piles exposed from erosion or included as part of the diver inspection are not included in this element. This element is for all columns/pile extensions regardless of protective system.'},
{number: 206, is_nbe: 'Y', is_protective: 'N', cat_key: '2', type_key: '21', mat_key: '5', short_name: 'Tim Col or Pile Ext', long_name: 'Timber Column', quantity_unit: 'each', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines only those timber columns or pile extensions. Piles exposed from erosion or included as part of the diver inspection are not included in this element. This element is for all columns/pile extensions regardless of protective system.'},
{number: 207, is_nbe: 'Y', is_protective: 'N', cat_key: '2', type_key: '21', mat_key: '4', short_name: 'Stl Tower', long_name: 'Steel Tower', quantity_unit: 'feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines only those steel built up or framed tower supports. This element is for all columns/pile extensions regardless of protective system.'},
{number: 208, is_nbe: 'Y', is_protective: 'N', cat_key: '2', type_key: '21', mat_key: '4', short_name: 'Timber Trestle', long_name: 'Timber Trestle', quantity_unit: 'feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines only those framed timber supports. This element is for all timber trestle/towers regardless of protective system.'},
{number: 210, is_nbe: 'Y', is_protective: 'N', cat_key: '2', type_key: '21', mat_key: '4', short_name: 'Re Conc Pier Wall', long_name: 'Reinforced Concrete Pier Wall', quantity_unit: 'feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines those reinforced concrete pier walls. This is for all pier walls regardless of protective systems.'},
{number: 211, is_nbe: 'Y', is_protective: 'N', cat_key: '2', type_key: '21', mat_key: '6', short_name: 'Other Pier Wall', long_name: 'Other Pier Wall', quantity_unit: 'feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines those pier walls constructed of other materials. This is for all pier walls regardless of protective systems.'},
{number: 212, is_nbe: 'Y', is_protective: 'N', cat_key: '2', type_key: '24', mat_key: '4', short_name: 'Timber Pier Wall', long_name: 'Timber Pier Wall', quantity_unit: 'feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines those timber pier walls that include pile, timber sheet material and filler. This is for all pier walls regardless of protective systems.'},
{number: 213, is_nbe: 'Y', is_protective: 'N', cat_key: '2', type_key: '24', mat_key: '4', short_name: 'Masonry Pier Wall', long_name: 'Masonry Pier Wall', quantity_unit: 'feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines those pier walls constructed of block or stone. The block or stone may be placed with or without mortar. This is for all pier walls regardless of protective systems.'},
{number: 215, is_nbe: 'Y', is_protective: 'N', cat_key: '2', type_key: '24', mat_key: '4', short_name: 'Re Conc Abutment', long_name: 'Reinforced Concrete Abutment', quantity_unit: 'feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines reinforced concrete abutments. This includes the sheet material retaining the embankment and wing walls, abutment extensions, and any other monolithically placed concrete elements. This is for all abutments regardless of protective systems.'},
{number: 216, is_nbe: 'Y', is_protective: 'N', cat_key: '2', type_key: '24', mat_key: '4', short_name: 'Timber Abutment', long_name: 'Timber Abutment', quantity_unit: 'feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines timber abutments. This includes the sheet material retaining the embankment, wing walls, and abutment extensions. This is for all abutments regardless of protective systems.'},
{number: 217, is_nbe: 'Y', is_protective: 'N', cat_key: '2', type_key: '24', mat_key: '6', short_name: 'Masonry Abutment', long_name: 'Masonry Abutment', quantity_unit: 'feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines those abutments constructed of block or stone. The block or stone may be placed with or without mortar. This is for all abutments regardless of protective systems.'},
{number: 218, is_nbe: 'Y', is_protective: 'N', cat_key: '2', type_key: '24', mat_key: '6', short_name: 'Other Abutments', long_name: 'Other Abutments', quantity_unit: 'feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines other material abutments systems. This includes the sheet material retaining the embankment, wing walls, and abutment extensions. This is for all abutments regardless of protective systems.'},
{number: 219, is_nbe: 'Y', is_protective: 'N', cat_key: '2', type_key: '22', mat_key: '4', short_name: 'Stl Abutment', long_name: 'Steel Abutment', quantity_unit: 'feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines steel abutments. This includes the sheet material retaining the embankment, wing walls, and abutment extensions. This is for all abutments regardless of protective systems.'},
{number: 220, is_nbe: 'Y', is_protective: 'N', cat_key: '2', type_key: '22', mat_key: '4', short_name: 'Re Conc Pile Cap/Ftg', long_name: 'Reinforced Concrete Pile Cap/Footing', quantity_unit: 'feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines only those reinforced concrete piles that are typically submerged in water and are visible for inspection. The exposure may be intentional or caused by erosion.'},
{number: 225, is_nbe: 'Y', is_protective: 'N', cat_key: '2', type_key: '22', mat_key: '1', short_name: 'Steel Pile', long_name: 'Steel Pile', quantity_unit: 'each', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines only those steel piles that are continuously submerged in water and are visible for inspection. Piles exposed from erosion or are part of the diver inspection are included in this element. This element is for all pile extensions regardless of protective system.'},
{number: 226, is_nbe: 'Y', is_protective: 'N', cat_key: '2', type_key: '22', mat_key: '3', short_name: 'Pre Conc Pile', long_name: 'Prestressed Concrete Pile', quantity_unit: 'each', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines only those prestressed piles that are continuously submerged in water and are visible for inspection. Piles exposed from erosion or are part of the diver inspection are included in this element. This element is for all columns/pile extensions regardless of protective system.'},
{number: 227, is_nbe: 'Y', is_protective: 'N', cat_key: '2', type_key: '22', mat_key: '4', short_name: 'Re Conc Pile', long_name: 'Reinforced Concrete Pile', quantity_unit: 'each', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines only those reinforced concrete piles that are typically submerged in water and are visible for inspection. Piles exposed from erosion or are part of the diver inspection are included in this element. This element is for all columns/pile extensions regardless of protective system.'},
{number: 228, is_nbe: 'Y', is_protective: 'N', cat_key: '2', type_key: '22', mat_key: '5', short_name: 'Timber Pile', long_name: 'Timber Pile', quantity_unit: 'each', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines only those timber piles that are typically submerged in water and are visible for inspection. Piles exposed from erosion or are part of the diver inspection are included in this element. This element is for all columns/pile extensions regardless of protective system.'},
{number: 229, is_nbe: 'Y', is_protective: 'N', cat_key: '2', type_key: '22', mat_key: '5', short_name: 'Other Pile', long_name: 'Other Pile', quantity_unit: 'each', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines other material piles that are visible for inspection. Piles exposed from erosion or scour and piles visible during an underwater inspection are included in this element. This element is for all other material piles regardless of protective system.'},
{number: 231, is_nbe: 'Y', is_protective: 'N', cat_key: '2', type_key: '23', mat_key: '2', short_name: 'Steel Pier Cap', long_name: 'Steel Pier Cap', quantity_unit: 'feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines those steel pier caps that support girders and transfer load into piles. This element is for all steel pier caps regardless of protective system.'},
{number: 233, is_nbe: 'Y', is_protective: 'N', cat_key: '2', type_key: '23', mat_key: '3', short_name: 'Pre Conc Pier Cap', long_name: 'Prestressed Concrete Pier Cap', quantity_unit: 'feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines those prestressed concrete pier caps that support girders and transfer load into piles. This element is for all caps regardless of protective system.'},
{number: 234, is_nbe: 'Y', is_protective: 'N', cat_key: '2', type_key: '23', mat_key: '4', short_name: 'Re Conc Pier Cap', long_name: 'Reinforced Concrete Pier Cap', quantity_unit: 'feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines those reinforced concrete caps that support girders and transfer load into piles. This element is for all pier caps regardless of protective system.'},
{number: 235, is_nbe: 'Y', is_protective: 'N', cat_key: '2', type_key: '23', mat_key: '5', short_name: 'Timber Pier Cap', long_name: 'Timber Pier Cap', quantity_unit: 'feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines those timber caps that support girders that transfer load into piles. This element is for all timber pier caps regardless of protective system.'},
{number: 236, is_nbe: 'Y', is_protective: 'N', cat_key: '2', type_key: '23', mat_key: '5', short_name: 'Other Pier Cap', long_name: 'Other Pier Cap', quantity_unit: 'feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines other material pier caps that support girders that transfer load into piles or columns, and is for all other material pier caps regardless of protective system.'},
{number: 240, is_nbe: 'Y', is_protective: 'N', cat_key: '2', type_key: '25', mat_key: '1', short_name: 'Steel Culvert', long_name: 'Steel Culvert', quantity_unit: 'feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines steel culverts, including arched, round or elliptical pipes.'},
{number: 241, is_nbe: 'Y', is_protective: 'N', cat_key: '2', type_key: '25', mat_key: '4', short_name: 'Re Conc Culvert', long_name: 'Reinforced Concrete Culvert', quantity_unit: 'feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines reinforced concrete culverts, including box, arched, round or elliptical shapes.'},
{number: 242, is_nbe: 'Y', is_protective: 'N', cat_key: '2', type_key: '25', mat_key: '5', short_name: 'Timber Culvert', long_name: 'Timber Culvert', quantity_unit: 'feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines all timber culverts regardless of the protection systems used.'},
{number: 243, is_nbe: 'Y', is_protective: 'N', cat_key: '2', type_key: '25', mat_key: '6', short_name: 'Other Culvert', long_name: 'Other Culvert', quantity_unit: 'feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines other material type culverts, including arches, round or elliptical pipes. These culverts are not included in steel, concrete or timber material types.'},
{number: 244, is_nbe: 'Y', is_protective: 'N', cat_key: '2', type_key: '24', mat_key: '2', short_name: 'Masonry Culvert', long_name: 'Masonry Culvert', quantity_unit: 'feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines masonry block or stone culverts.'},
{number: 245, is_nbe: 'Y', is_protective: 'N', cat_key: '2', type_key: '24', mat_key: '2', short_name: 'Pre Concrete Culvert', long_name: 'Prestressed Concrete Culvert', quantity_unit: 'feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines all prestressed concrete culverts.'},
{number: 300, is_nbe: 'N', is_protective: 'N', cat_key: '3', type_key: '03', mat_key: '6', short_name: 'Strip Seal Exp Joint', long_name: 'Strip Seal Expansion Joint', quantity_unit: 'feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines those expansion joint devices which utilize a neoprene type waterproof gland with some type of metal extrusion or other system to anchor the gland.'},
{number: 301, is_nbe: 'N', is_protective: 'N', cat_key: '3', type_key: '03', mat_key: '6', short_name: 'Pourable Joint Seal', long_name: 'Pourable Joint Seal', quantity_unit: 'feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This Element defines on those joints filled with a pourable seal with or without a backer.'},
{number: 302, is_nbe: 'N', is_protective: 'N', cat_key: '3', type_key: '03', mat_key: '6', short_name: 'Compressn Joint Seal', long_name: 'Compression Joint Seal', quantity_unit: 'feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines only those joints filled with a pre-formed compression type seal. This joint does not have an anchor system to confine the seal.'},
{number: 303, is_nbe: 'N', is_protective: 'N', cat_key: '3', type_key: '03', mat_key: '6', short_name: 'Assem Jnt With Seal', long_name: 'Assembly Joint With Seal', quantity_unit: 'feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines only those joints filled with an assembly mechanism that have a seal.'},
{number: 304, is_nbe: 'N', is_protective: 'N', cat_key: '3', type_key: '03', mat_key: '6', short_name: 'Open Expansion Joint', long_name: 'Open Expansion Joint', quantity_unit: 'feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines only those joints that are open and not sealed.'},
{number: 305, is_nbe: 'N', is_protective: 'N', cat_key: '3', type_key: '03', mat_key: '6', short_name: 'Assem Jnt Wthut Seal', long_name: 'Assembly Joint Without Seal', quantity_unit: 'feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines only those assembly joints that are open and not sealed. These joint includes finger and sliding plate joints.'},
{number: 306, is_nbe: 'N', is_protective: 'N', cat_key: '3', type_key: '03', mat_key: '6', short_name: 'Other Joint', long_name: 'Other Joint', quantity_unit: 'feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines only those other joints that are not defined by any other joint element.'},
{number: 310, is_nbe: 'Y', is_protective: 'N', cat_key: '4', type_key: '04', mat_key: '6', short_name: 'Elastomeric Bearing', long_name: 'Elastomeric Bearing', quantity_unit: 'each', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines only those bridge bearings that are constructed primarily of elastomers, with or without fabric or metal reinforcement.'},
{number: 311, is_nbe: 'Y', is_protective: 'N', cat_key: '4', type_key: '04', mat_key: '6', short_name: 'Moveable Bearing', long_name: 'Movable Bearing', quantity_unit: 'each', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines only those bridge bearings which provide for both rotation and longitudinal movement by means of roller, rocker, or sliding mechanisms.'},
{number: 312, is_nbe: 'Y', is_protective: 'N', cat_key: '4', type_key: '04', mat_key: '6', short_name: 'Enclosed Bearing', long_name: 'Enclosed/Concealed Bearing', quantity_unit: 'each', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines only those bridge bearings that are enclosed so that they are not open for detailed inspection.'},
{number: 313, is_nbe: 'Y', is_protective: 'N', cat_key: '4', type_key: '04', mat_key: '6', short_name: 'Fixed Bearing', long_name: 'Fixed Bearing', quantity_unit: 'each', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines only those bridge bearings that provide for rotation only (no longitudinal movement).'},
{number: 314, is_nbe: 'Y', is_protective: 'N', cat_key: '4', type_key: '04', mat_key: '6', short_name: 'Pot Bearing', long_name: 'Pot Bearing', quantity_unit: 'each', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines those high load bearings with confined elastomer. The bearing may be fixed against horizontal movement, guided to allow sliding in one direction, or floating to allow sliding in any direction.'},
{number: 315, is_nbe: 'Y', is_protective: 'N', cat_key: '4', type_key: '04', mat_key: '6', short_name: 'Disk Bearing', long_name: 'Disk Bearing', quantity_unit: 'each', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines those high load bearings with a hard plastic disk. This bearing may be fixed against horizontal movement, guided to allow movement in one direction, or floating to allow sliding in any direction.'},
{number: 316, is_nbe: 'Y', is_protective: 'N', cat_key: '4', type_key: '04', mat_key: '6', short_name: 'Other Bearing', long_name: 'Other Bearing', quantity_unit: 'each', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines all other material bridge bearings regardless of translation or rotation constraints.'},
{number: 320, is_nbe: 'N', is_protective: 'N', cat_key: '5', type_key: '05', mat_key: '3', short_name: 'Pre Conc Appr Slab', long_name: 'Prestress Concrete Approach Slab', quantity_unit: 'sq feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines those structural sections, between the abutment and the approach pavement that are constructed of prestressed (post tensioned) reinforced concrete.'},
{number: 321, is_nbe: 'N', is_protective: 'N', cat_key: '5', type_key: '05', mat_key: '4', short_name: 'Re Conc Approach Slab', long_name: 'Reinforced Concrete Approach Slab', quantity_unit: 'sq feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This Element defines those structural sections, between the abutment and the approach pavement that are constructed of mild steel reinforced concrete.'},
{number: 330, is_nbe: 'Y', is_protective: 'N', cat_key: '1', type_key: '11', mat_key: '6', short_name: 'Metal Bridge Railing', long_name: 'Metal Bridge Railing', quantity_unit: 'feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines all types and shapes of metal bridge railing. Steel, aluminum, metal beam, rolled shapes, etc. will all be considered part of this element.  Included in this element are the posts of metal, timber or concrete, blocking and curb.'},
{number: 331, is_nbe: 'Y', is_protective: 'N', cat_key: '1', type_key: '11', mat_key: '4', short_name: 'Re Conc Bridge Railing', long_name: 'Reinforced Concrete Bridge Railing', quantity_unit: 'feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines all types and shapes of reinforced concrete bridge railing. All elements of the railing must be concrete.'},
{number: 332, is_nbe: 'Y', is_protective: 'N', cat_key: '1', type_key: '11', mat_key: '5', short_name: 'Timb Bridge Railing', long_name: 'Timber Bridge Railing', quantity_unit: 'feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines all types and shapes of timber bridge railing. Included in this element are the posts of timber, metal or concrete, blocking and curb.'},
{number: 333, is_nbe: 'Y', is_protective: 'N', cat_key: '1', type_key: '11', mat_key: '2', short_name: 'Other Bridge Railing', long_name: 'Other Bridge Railing', quantity_unit: 'feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines all types and shapes of bridge railing except those defined as metal, concrete, timber or masonry.'},
{number: 334, is_nbe: 'Y', is_protective: 'N', cat_key: '1', type_key: '11', mat_key: '2', short_name: 'Masry Bdge Rling', long_name: 'Masonry Bridge Railing', quantity_unit: 'feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines all types and shapes of masonry block or stone bridge railing. All elements of the railing must be masonry block or stone.'},
{number: 510, is_nbe: 'N', is_protective: 'Y', cat_key: '5', type_key: '05', mat_key: '6', short_name: 'Wearing Surfaces', long_name: 'Wearing Surfaces', quantity_unit: 'sq feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element is for all decks/slabs that have overlays made with flexible (asphaltic concrete), semi rigid (epoxy and polyester material) or rigid (portland cement) materials.'},
{number: 515, is_nbe: 'N', is_protective: 'Y', cat_key: '5', type_key: '05', mat_key: '6', short_name: 'Steel Protective Coating', long_name: 'Steel Protective Coating', quantity_unit: 'sq feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'The element is for steel elements that have a protective coating such as paint, galvanization or other top coat steel corrosion inhibitor.'},
{number: 520, is_nbe: 'N', is_protective: 'Y', cat_key: '5', type_key: '05', mat_key: '6', short_name: 'Conc Re Prot Sys', long_name: 'Concrete Reinforcing Steel Protective System', quantity_unit: 'sq feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element defines all types of protective systems used to protect decks or slabs regardless of the type.'},
{number: 521, is_nbe: 'N', is_protective: 'Y', cat_key: '5', type_key: '05', mat_key: '6', short_name: 'Conc Prot Coating', long_name: 'Concrete Protective Coating', quantity_unit: 'sq feet', created_at: '2012-12-12 00:00:00', updated_at: '2012-12-12 00:00:00', description: 'This element is for concrete elements that have a protective coating applied to them. These coating include silane/siloxane water proofers, crack sealers such as High Molecular Weight Methacrylate (HMWM) or any top coat barrier that protects concrete from deterioration and reinforcing steel from corrosion.'}
]

inspection_programs = [
  {name: 'Ancillary', active: true, description: ''},
  {name: 'Minor', active: true, description: ''},
  {name: 'Miscellaneous', active: true, description: ''},
  {name: 'Inventory Only', active: true, description: ''},
  {name: 'Off-System', active: true, description: ''},
  {name: 'On-System', active: true, description: ''},
  {name: 'Tunnel', active: true, description: ''},
  {name: 'Wall', active: true, description: ''}
]

# These mappings are based solely on Materials in Appendix D of DefectMapping.pdf
defect_definitions_element_definitions = {
      1000 => [28, 29, 30, 60, 65, 102, 106, 107, 112, 113, 118, 120, 136, 141, 142, 147, 148, 149, 152, 157, 161, 162, 202, 203,  207, 210, 211, 218, 219, 225, 229, 231, 236, 240, 243, 300, 304, 310, 311, 313, 314, 316, 330, 333],
      1010 => [28, 29, 30, 60, 65, 102, 106, 107, 112, 113, 118, 120, 136, 141, 142, 147, 148, 149, 152, 157, 161, 162, 202, 203,  207, 210, 211, 218, 219, 225, 229, 231, 236, 240, 243, 300, 304, 310, 311, 313, 314, 316, 330, 333],
      1020 => [28, 29, 30, 60, 65, 102, 106, 107, 112, 113, 118, 120, 136, 141, 142, 147, 148, 149, 152, 157, 161, 162, 202, 203,  207, 210, 211, 218, 219, 225, 229, 231, 236, 240, 243, 300, 304, 310, 311, 313, 314, 316, 330, 333],
      1080 => [12, 13, 15, 16, 38, 39, 60, 65, 104, 105, 106, 109, 110, 112, 115, 116, 142, 143, 144, 145, 154, 155, 157, 203, 204, 205, 210, 211, 213, 215, 217, 218, 220, 226, 227, 229, 233, 234, 236, 241, 243, 244, 245, 300, 301, 302, 303, 304, 305, 306, 320, 321, 331, 333, 334],
      1090 => [12, 13, 15, 16, 38, 39, 104, 105, 109, 110, 115, 116, 143, 144, 154, 155, 204, 205, 210, 215, 220, 226, 227, 233, 234, 241, 245, 320, 321, 331],
      1100 => [13, 15, 39, 104, 109, 115, 143, 154, 204, 226, 233, 245, 320],
      1110 => [13, 15, 39, 104, 109, 115, 143, 154, 204, 226, 233, 245, 320],
      1120 => [12, 13, 15, 16, 38, 39, 60, 65, 104, 105, 106, 109, 110, 112, 115, 116, 142, 143, 144, 145, 154, 155, 157, 203, 204, 205, 210, 211, 213, 215, 217, 218, 220, 226, 227, 229, 233, 234, 236, 241, 243, 244, 245, 300, 301, 302, 303, 304, 305, 306, 320, 321, 331, 333, 334],
      1130 => [12, 16, 38, 60, 65, 110, 112, 116, 118, 142, 144, 155, 157, 203, 205, 210, 211, 215, 218, 220, 227, 229, 234, 236, 241, 243, 321, 331, 333],
      1140 => [31, 54, 111, 117, 135, 146, 156, 206, 208, 212, 216, 228, 235, 242, 332],
      1150 => [31, 54, 111, 117, 135, 146, 156, 206, 208, 212, 216, 228, 235, 242, 332],
      1160 => [31, 54, 111, 117, 135, 146, 156, 206, 208, 212, 216, 228, 235, 242, 332],
      1170 => [31, 54, 111, 117, 135, 146, 156, 206, 208, 212, 216, 228, 235, 242, 332],
      1180 => [31, 54, 111, 117, 135, 146, 156, 206, 208, 212, 216, 228, 235, 242, 332],
      1190 => [12, 13, 15, 16, 38, 39, 104, 105, 109, 110, 115, 116, 143, 144, 154, 155, 204, 205, 210, 215, 220, 226, 227, 233, 234, 241, 245, 320, 321, 331],
      1220 => [60, 65, 106, 112, 118, 136, 142, 149, 157, 203, 211, 218, 229, 236, 243, 306, 316, 333],
      1610 => [145, 213, 217, 244, 334],
      1620 => [145, 213, 217, 244, 334],
      1630 => [145, 213, 217, 244, 334],
      1640 => [145, 213, 217, 244, 334],
      1900 => [12, 13, 15, 16, 28, 29, 30, 31, 38, 39, 54, 60, 65, 102, 104, 105, 106, 107, 109, 110, 111, 112, 113, 115, 116, 117, 118, 120, 135, 136, 141, 142, 143, 144, 145, 146, 147, 148, 149, 152, 154, 155, 156, 157, 161, 162, 202, 203, 204, 205, 206, 207, 208, 210, 211, 212, 213, 215, 216, 217, 218, 219, 220, 225, 226, 227, 228, 229, 231, 233, 234, 235, 236, 240, 241, 242, 243, 244, 245, 300, 301, 302, 303, 304, 305, 306, 310, 311, 312, 313, 314, 315, 316, 320, 321, 330, 331, 332, 333, 334],
      2210 => [310, 311, 312, 313, 314, 315, 316],
      2220 => [310, 311, 312, 313, 314, 315, 316],
      2230 => [310],
      2240 => [310, 311, 312, 313, 314, 315, 316],
      2310 => [300, 301, 302, 303, 304, 305, 306],
      2320 => [300, 301, 302, 303, 304, 305, 306],
      2330 => [300, 301, 302, 303, 304, 305, 306],
      2340 => [300, 301, 302, 303, 304, 305, 306],
      2350 => [300, 301, 302, 303, 304, 305, 306],
      2360 => [300, 301, 302, 303, 304, 305, 306],
      2370 => [300, 301, 302, 303, 304, 305, 306],
      3210 => [510],
      3220 => [510],
      3230 => [510],
      3410 => [515],
      3420 => [515],
      3430 => [515],
      3440 => [515],
      3510 => [521],
      3540 => [521],
      3600 => [520],
      4000 => [12, 13, 15, 16, 28, 29, 30, 31, 38, 39, 54, 60, 65, 102, 104, 105, 106, 107, 109, 110, 111, 112, 113, 115, 116, 117, 118, 120, 135, 136, 141, 142, 143, 144, 145, 146, 147, 148, 149, 152, 154, 155, 156, 157, 161, 162, 202, 203, 204, 205, 206, 207, 208, 210, 211, 212, 213, 215, 216, 217, 218, 219, 220, 225, 226, 227, 228, 229, 231, 233, 234, 235, 236, 240, 241, 242, 243, 244, 245, 300, 301, 302, 303, 304, 305, 306, 310, 311, 312, 313, 314, 315, 316, 320, 321, 330, 331, 332, 333, 334],
      6000 => [12, 13, 15, 16, 28, 29, 30, 31, 38, 39, 54, 60, 65, 102, 104, 105, 106, 107, 109, 110, 111, 112, 113, 115, 116, 117, 118, 120, 135, 136, 141, 142, 143, 144, 145, 146, 147, 148, 149, 152, 154, 155, 156, 157, 161, 162, 202, 203, 204, 205, 206, 207, 208, 210, 211, 212, 213, 215, 216, 217, 218, 219, 220, 225, 226, 227, 228, 229, 231, 233, 234, 235, 236, 240, 241, 242, 243, 244, 245, 300, 301, 302, 303, 304, 305, 306, 310, 311, 312, 313, 314, 315, 316, 320, 321, 330, 331, 332, 333, 334],
      7000 => nil
    }

merge_tables = %w{ organization_types asset_types asset_subtypes roles system_config_extensions }

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

replace_tables = %w{ operational_status_types route_signing_prefixes structure_material_types design_construction_types bridge_condition_rating_types channel_condition_types bridge_appraisal_rating_types strahnet_designation_types deck_structure_types  wearing_surface_types membrane_types deck_protection_types scour_critical_bridge_types structure_status_types structure_agent_types element_materials element_classifications defect_definitions inspection_types feature_safety_types assembly_types reference_feature_types bridge_posting_types load_rating_method_types design_load_types bridge_toll_types historical_significance_types service_under_types service_on_types service_level_types functional_classes traffic_direction_types culvert_condition_types inspection_programs
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

table_name = 'element_definitions'
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
  x = klass.new(row.except(:is_nbe, :cat_key, :type_key, :mat_key))
  x.element_material = ElementMaterial.find_by(code: row[:mat_key])
  x.element_classification = 
    ElementClassification.find_by(name: row[:is_nbe] == 'Y' ? 'NBE' : 'BME')
  x.save!
end

table_name = 'defect_definitions_element_definitions'
puts "  Loading #{table_name}"
if is_mysql
  ActiveRecord::Base.connection.execute("TRUNCATE TABLE #{table_name};")
elsif is_sqlite
  ActiveRecord::Base.connection.execute("DELETE FROM #{table_name};")
else
  ActiveRecord::Base.connection.execute("TRUNCATE #{table_name} RESTART IDENTITY;")
end
data = eval(table_name)
data.each do |defect, elements|
  DefectDefinition.find_by(number: defect).element_definition_ids =
    unless elements
      ElementDefinition.pluck(:id)
    else
      ElementDefinition.where(number: elements).pluck(:id)
    end
  end


