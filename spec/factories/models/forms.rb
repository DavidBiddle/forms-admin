FactoryBot.define do
  factory :form, class: "Form" do
    sequence(:name) { |n| "Form #{n}" }
    submission_email { Faker::Internet.email(domain: "example.gov.uk") }
    privacy_policy_url { Faker::Internet.url(host: "gov.uk") }
    live_at { nil }
    missing_sections { nil }

    trait :new_form do
      submission_email { "" }
      privacy_policy_url { "" }
      pages { [] }
    end

    trait :live do
      live_at { Time.zone.now }
    end

    trait :with_pages do
      transient do
        pages_count { 5 }
      end

      pages do
        Array.new(pages_count) { association(:page) }
      end
    end
  end
end