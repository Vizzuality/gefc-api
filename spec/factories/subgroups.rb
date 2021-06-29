FactoryBot.define do
  factory :subgroup do
    association :group
    name_en { "factory subgroup" }
    name_cn { "社会经济" }
  end
end
