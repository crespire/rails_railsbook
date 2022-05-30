FactoryBot.define do
  factory :comment do
    association :user
    association :post
    content { Faker::Hipster.paragraphs(number: 2).join }
  end
end