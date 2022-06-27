FactoryBot.define do
  factory :post do
    content { Faker::Hipster.paragraphs(number: 2).join }

    association :user

    trait :with_comments do
      transient do
        comment_count { 0 }
      end

      after(:create) do |post, eval|
        create_list(:comment, eval.comment_count, post: post, user: post.user)
        post.reload
      end
    end
  end
end