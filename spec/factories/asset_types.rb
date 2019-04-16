FactoryBot.define do

  factory :asset_type do
    name { "Test Asset Type" }
    class_name { "TransamAsset" } # For core, no concrete classes exist
    description { "Test Asset Type" }
    active { true }
    display_icon_name { "fa fa-bus" }
    map_icon_name { "redIcon" }
  end

  factory :highway_structure_type, :class => :asset_type do
    name { "Highway Structure" }
    class_name { "HighwayStructure" } # For core, no concrete classes exist
    description { "Highway Structure" }
    active { true }
    display_icon_name { "fa fa-structure" }
    map_icon_name { "redIcon" }
  end

  factory :bridge_type, :class => :asset_type do
    name { "Bridge" }
    class_name { "Bridge" } # For core, no concrete classes exist
    description { "Bridge" }
    active { true }
    display_icon_name { "fa fa-bridge" }
    map_icon_name { "redIcon" }
  end

  factory :culvert_type, :class => :asset_type do
    name { "Culvert" }
    class_name { "Culvert" } # For core, no concrete classes exist
    description { "Culvert" }
    active { true }
    display_icon_name { "fa fa-culvert" }
    map_icon_name { "blueIcon" }
  end
end
