FactoryBot.define do
  factory :element do
    association :element_definition
    association :inspection
  end
end
