FactoryBot.define do
  factory :agent do
    sequence(:name) { |n| "name#{n}" }
    sequence(:email) { |n| "dentolo#{n}@dentolo.com" }
  end
end
