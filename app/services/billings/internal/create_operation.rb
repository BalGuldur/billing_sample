module Billings
  module Internal
    class CreateOperation
      class Contract < Dry::Validation::Contract
        config.messages.backend = :i18n

        params do
          required(:reason) # TODO: Add type check string
          required(:run_at) # TODO: Add type check isData
          required(:subject)
        end
      end

      include Dry::Transaction

      step :validate_input
      step :create_operation

      private

      def validate_input(input)
        ValidateContract.new.call(input: input, contract: Contract)
      end

      def create_operation(input)
        begin
          op = Billing::Operation.new(
            reason: input[:reason],
            run_at: input[:run_at],
            subject_id: input[:subject].id,
            subject_type: input[:subject].class.to_s
          )
          if op.save
            Success(op)
          else
            Failure(error: :can_not_create_operation, errors: op.errors)
          end
        rescue StandardError => e
          Failure(error: :db_error, errors: [e])
        end
      end
    end
  end
end
