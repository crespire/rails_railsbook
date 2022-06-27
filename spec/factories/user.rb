FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    name { Faker::Name.name }
    password { Faker::Internet.password }

    factory :user_with_posts do
      transient do
        post_count { 5 }
      end

      after(:create) do |user, eval|
        create_list(:post, eval.post_count, user: user)
        user.reload
      end
    end
  end
end