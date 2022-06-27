FactoryBot.define do
  factory :comment do
    content { Faker::Hipster.paragraphs(number: 2).join }

    association :user
    association :post
  end
end