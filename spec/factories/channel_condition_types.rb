FactoryBot.define do
  factory :channel_condition_type do
    sequence(:name) { |n| "channel_condition_type_#{n}" }
    active { true }
  end
end
