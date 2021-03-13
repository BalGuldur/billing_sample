FactoryBot.define do
  factory :operation, :class => Billing::Operation do |f|
    f.reason { :test_reason }
    f.run_at { DateTime.now }
    f.subject_id { 1 }
    f.subject_type { "RandomClass" }
  end
end