FactoryBot.define do
  factory :account, :class => Billing::Account do |f|
    f.external_id { generate(:random_int_id) }
  end
end