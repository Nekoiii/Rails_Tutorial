# factories/users.rb

FactoryBot.define do
  factory :user do
    activated { true }
    activated_at { Time.zone.now }
    password_digest { User.digest('password') }

    trait :admin do
      admin { true }
    end

    trait :inactive do
      activated { false }
    end

    factory :test_user_1, traits: [:admin] do
      name { 'Test User 1' }
      email { 'test_user@1.com' }
    end

    factory :test_user_2 do
      name { 'Test User 2' }
      email { 'test_user@2.com' }
    end

    factory :test_user_3 do
      name { 'Test User 3' }
      email { 'test_user@3.com' }
    end

    factory :test_user_4 do
      name { 'Test User 4' }
      email { 'test_user@4.com' }
    end

    factory :inactive_user, traits: [:inactive] do
      name { 'Inactive User' }
      email { 'inactive@user.com' }
      admin { false }
    end

    sequence(:email) { |n| "user-#{n}@example.com" }
    sequence(:name, aliases: [:username]) { |n| "User #{n}" }
  end
end
