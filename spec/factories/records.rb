FactoryBot.define do
  factory :record do
    association :indicator
    association :unit
    association :region
    year { 2021 }
    value { 100 }
  end
end
