FactoryBot.define do
  factory :roadbed_line do
    object_key { "MyString" }
    roadbed { nil }
    inspection { nil }
    number { 1 }
    entry { 1.5 }
    exit { 1.5 }
  end
end
