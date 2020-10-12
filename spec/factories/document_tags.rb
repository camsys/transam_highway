FactoryBot.define do
  factory :document_tag do
    name { "TAG" }
    description { "Test tag" }
    pattern { "TAG" }
    allowed_extensions { "pdf" }
    association :document_folder, factory: :document_folder
    active { true }
  end
end
