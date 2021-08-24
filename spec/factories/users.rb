FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    username { Faker::Name.name }
    password { "password" }
    password_confirmation { "password" }

    trait :admin do
      role { "admin" }
    end
  end
end
