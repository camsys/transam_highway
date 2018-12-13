FactoryBot.define do

  sequence :asset_tag do |n|
    "CONCRETE_#{n}"
  end

  trait :basic_asset_attributes do
    association :organization, :factory => :organization_basic
    asset_tag
    purchased_new { true }
    purchase_date { 1.year.ago }
    purchase_cost { 250000 }
    manufacture_year { "2000" }
    in_service_date { Date.new(2001,1,1) }
  end

  trait :highway_structure_attributes do
    basic_asset_attributes
  end

  trait :bridge_attributes do
    highway_structure_attributes
    association :asset_subtype, :factory => :bridge_subtype
  end

  factory :bridge, :class => :bridge do
    bridge_attributes
  end

end
