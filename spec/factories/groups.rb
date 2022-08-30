require "faker"

FactoryBot.define do
  factory :group do
    name_en { Faker::Name.unique.name }
    name_cn { "社会经济" }
  end
end
