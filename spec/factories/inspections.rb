FactoryBot.define do
  factory :inspection do
    inspection_type_id { 1 }
    association :highway_structure
  end
end
