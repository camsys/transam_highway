FactoryBot.define do
  factory :inspection do
    association :inspection_type
    association :highway_structure
  end
end
