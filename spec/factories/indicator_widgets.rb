FactoryBot.define do
  factory :indicator_widget do
    association :indicator
    association :widget
  end
end
