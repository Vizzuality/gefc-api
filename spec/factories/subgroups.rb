require "faker"

FactoryBot.define do
  factory :subgroup do
    association :group
    name_en { Faker::Name.unique.name }
    name_cn { "社会经济" }
    by_default { false }
  end
end
