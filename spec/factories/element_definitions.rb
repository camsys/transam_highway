FactoryBot.define do
  factory :element_definition do
    sequence(:number) { |n| "element_definition_number_#{n}" }
  end
end
