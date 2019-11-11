FactoryBot.define do
  factory :inspection_type_setting do
    inspection_type_id { 1 }
    association :highway_structure
    frequency_months { 24 }
    is_required { true }
  end
end
