FactoryBot.define do
  factory :indicator do
    association :subgroup
    name_en { 'factory indicator' }
    name_cn { "社会经济" }
  end
end
