require 'billing'
module Billing
  class Transaction < ApplicationRecord
    belongs_to :account, class_name: 'Billing::Account', foreign_key: 'billing_account_id'
    belongs_to :operation, class_name: 'Billing::Operation', foreign_key: 'billing_operation_id'
    belongs_to :money_type, class_name: 'Billing::MoneyType', foreign_key: 'billing_money_type_id'

    # before_destroy { throw(:abort) }
  end
end
