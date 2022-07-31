FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    name { Faker::Name.name }
    password { Faker::Internet.password }

    trait :with_posts do
      transient do
        post_count { 0 }
      end

      after(:create) do |user, eval|
        create_list(:post, eval.post_count, user: user)
        user.reload
      end
    end

    trait :with_pic_attached do
      after(:create) do |user|
        user.avatar.attach(io: File.open(Rails.root.join('spec', 'factories', 'images', 'rabbit.jpeg')), filename: 'rabbit.jpeg', content_type: 'image/jpeg')
      end
    end

    # Using gravatar for my own email to test.
    trait :with_external_pic do
      after(:create) do |user|
        user.update(external_picture: 'https://secure.gravatar.com/avatar/5eeb81b1d66dccd48da7052a32ebf016.jpg')
      end
    end

    trait :with_both_pics do
      after(:create) do |user|
        user.update(external_picture: 'https://secure.gravatar.com/avatar/5eeb81b1d66dccd48da7052a32ebf016.jpg')
        user.avatar.attach(io: File.open(Rails.root.join('spec', 'factories', 'images', 'rabbit.jpeg')), filename: 'rabbit.jpeg', content_type: 'image/jpeg')
      end
    end
  end
end
