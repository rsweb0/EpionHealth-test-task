FactoryBot.define do
  factory :response do
    screener
    question { "Test Question" }
    answer { 0 }
  end
end
