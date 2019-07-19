FactoryBot.define do
  factory :roadbed do
    name { "MyString" }
    roadway { nil }
    direction { "MyString" }
    number_of_lanes { 1 }
  end
end
