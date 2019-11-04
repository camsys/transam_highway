FactoryBot.define do
  factory :defect_location do
    association :defect
    object_key { "MyString" }
    guid { "" }
    quantity { 1.5 }
    location_description { "MyString" }
    location_distance { "" }
    condition_state { "MyString" }
    note { "MyString" }
  end
end
