module Billings
  class FillAccount
    REASON = 'fill_account'.freeze

    class Contract < Dry::Validation::Contract
      config.messages.backend = :i18n

      params do
        required(:account) # TODO: Add type check filled by Billing::Account
        required(:money_type) # TODO: Add type check filled by Billing::MoneyType
        required(:amount).filled(:float)
      end
      # TODO: Add default money type???
    end

    include Dry::Transaction(container: Containers::Base)

    around :transaction, with: 'transaction'

    step :validate_input
    # TODO: step create cash_flow (something like fill_withdraw)
    step :create_operation
    step :create_transactions
    map :format_output

    private

    def validate_input(input)
      ValidateContract.new.call(input: input, contract: Contract)
    end

    def create_operation(input)
      Internal::CreateOperation.new.call(reason: REASON, run_at: DateTime.current, subject: input[:account])
                               .fmap { |res| input.merge(created_operation: res) }
    end

    def create_transactions(input)
      Internal::CreateDoubleTransaction.new.call(
        debitor: Billing::Account.cash_book,
        creditor: input[:account],
        money_type: input[:money_type],
        operation: input[:created_operation],
        amount: input[:amount]
      ).fmap { |res| input.merge(created_transactions: res) }
    end

    def format_output(input)
      input.slice(:created_operation, :created_transactions)
    end
  end
end
