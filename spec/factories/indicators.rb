require 'faker'

FactoryBot.define do
  factory :indicator do
    association :subgroup
    name_en { Faker::Name.unique.name }
    name_cn { "社会经济" }
    by_default { false }
  end
end
