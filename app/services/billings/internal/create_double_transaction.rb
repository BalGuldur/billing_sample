module Billings
  module Internal
    class CreateDoubleTransaction
      class Contract < Dry::Validation::Contract
        config.messages.backend = :i18n

        params do
          required(:debitor) # who send money TODO: Add type check filled by Billing::Account
          required(:creditor) # who receive money TODO: Add type check filled by Billing::Account
          required(:money_type) # TODO: Add type check filled by Billing::MoneyType
          required(:operation) # TODO: Add type check filled by Billing::Operation
          required(:amount).filled(:float)
        end
      end

      include Dry::Transaction(container: Containers::Base)

      around :transaction, with: 'transaction'

      step :validate_input
      step :create_debitor_transaction
      step :create_creditor_transaction
      map :format_output

      private

      def validate_input(input)
        ValidateContract.new.call(input: input, contract: Contract)
      end

      def create_debitor_transaction(input)
        create_transaction(
          account: input[:debitor],
          amount: input[:amount],
          money_type: input[:money_type],
          operation: input[:operation]
        ).fmap { |res| input.merge(debitor_tr: res) }
      end

      def create_creditor_transaction(input)
        create_transaction(
          account: input[:creditor],
          amount: input[:amount],
          money_type: input[:money_type],
          operation: input[:operation]
        ).fmap { |res| input.merge(creditor_tr: res) }
      end

      def format_output(input)
        input.slice(:creditor_tr, :debitor_tr)
      end

      def create_transaction(**params)
        begin
          tr = Billing::Transaction.new(**params)
          if tr.save
            Success(tr)
          else
            Failure(error: :can_not_create_transaction, errors: tr.errors)
          end
        rescue StandardError => e
          Failure(error: :db_error, errors: [e])
        end
      end
    end
  end
end