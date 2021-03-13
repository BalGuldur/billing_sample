# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
case Rails.env
when "development"
  mt = Billing::MoneyType.find_or_create_by(sym_code: :RU)
  cash_book_account = Billing::Account.find_or_create_by(external_id: -1)
  client_account = Billing::Account.find_or_create_by(external_id: 1)
  operation = Billing::Operation.create(reason: :pay_to_platform, run_at: DateTime.now, subject_id: client_account.id, subject_type: client_account.class.name)
  Billing::Transaction.create(account: client_account, money_type: mt, operation: operation, amount: -100)
  Billing::Transaction.create(account: cash_book_account, money_type: mt, operation: operation, amount: 100)
when "production"
  mt = Billing::MoneyType.find_or_create_by(sym_code: :RU)
  cash_book_account = Billing::Account.find_or_create_by(external_id: 1) # it's cash_book account
end
