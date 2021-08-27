FactoryBot.define do
  factory :scenario do
    name { Faker::Name.unique.name }
  end
end
