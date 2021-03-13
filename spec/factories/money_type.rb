FactoryBot.define do
  factory :money_type, :class => Billing::MoneyType do |f|
    f.sym_code { :RU }
  end
end