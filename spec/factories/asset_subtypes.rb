FactoryBot.define do

  factory :asset_subtype do
    association :asset_type
    name { "Test Asset Subtype" }
    description { "Test Asset Subtype" }
    active { true }
  end

  factory :bridge_subtype, :class => :asset_subtype do
    association :asset_type, :factory => :bridge_type
    name { "Test Bridge Subtype" }
    description { "Test Bridge Subtype" }
    active { true }
  end

end
