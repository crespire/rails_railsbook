FactoryBot.define do
  factory :like do
    association :user
    association :likeable
  end
end