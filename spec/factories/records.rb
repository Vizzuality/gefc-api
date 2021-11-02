require 'faker'

FactoryBot.define do
  factory :record do
    association :indicator
    association :unit
    association :region
    year {Faker::Date.between(from: '2000-01-01', to: Date.today).year }
    value { 100 }
    category_1_en { nil }
    category_1_cn { nil }
  end
end
