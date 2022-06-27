FactoryBot.define do
  factory :post do
    content { Faker::Hipster.paragraphs(number: 2).join }

    association :user
  end
end