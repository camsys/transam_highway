FactoryBot.define do
  factory :inspection_type do
    name { 'Test Inspection Type' }
    code { 'TST' }
    description { 'An inspection used for tests.' }
    can_be_unscheduled { true }
    can_be_recurring { true }
    active { true }
  end
end