FactoryBot.define do
  factory :inspection_type_setting do
    association :inspection_type
    association :highway_structure
    frequency_months { 24 }
    is_required { true }
  end
end
