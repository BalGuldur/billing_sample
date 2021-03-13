require 'billing'
module Billing
  class Account < ApplicationRecord
    def self.cash_book
      Billing::Account.find_by(external_id: -1)
    end
  end
end
