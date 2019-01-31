FactoryBot.define do
  factory :processable_upload do
    class_name { "MyString" }
    file_status_type { nil }
    delayed_job { nil }
  end
end
