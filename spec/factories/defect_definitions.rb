FactoryBot.define do
  factory :defect_definition do
    sequence(:number) { |n| "defect_definition_number_#{n}" }
  end
end
