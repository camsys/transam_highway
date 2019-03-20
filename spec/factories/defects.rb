FactoryBot.define do
  factory :defect do
    association :defect_definition
    association :inspection
    association :element
  end
end
