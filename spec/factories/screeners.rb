FactoryBot.define do
  factory :screener do
    check_in
    phq_level { 1 }
  end
end
