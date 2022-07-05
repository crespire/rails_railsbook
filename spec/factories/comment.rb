FactoryBot.define do
  factory :comment do
    content { Faker::Hipster.sentence(word_count: 4) }

    association :user
    association :post
  end
end