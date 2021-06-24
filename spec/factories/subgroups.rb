FactoryBot.define do
  factory :subgroup do
    association :group
    name { "factory subgroup" }
  end
end
