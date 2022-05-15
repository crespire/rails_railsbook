FactoryBot.define do
  factory :post do
    association :user
    content { Faker::Hipster.paragraphs(number: 2).join }
  end
end