FactoryBot.define do
  factory :indicator do
    association :subgroup
    name { 'factory indicator' }
  end
end
