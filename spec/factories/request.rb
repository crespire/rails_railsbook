FactoryBot.define do
  factory :request do
    association :user
    association :friend, factory: :user

    trait :accepted do
      accepted { true }
    end
  end
end
