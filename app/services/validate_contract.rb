require "dry/monads"
Dry::Validation.load_extensions(:monads)

# Сервис валидации контрактов, лежит в корне потому что:
# - общий для других сервисов
# - модуль Base (раньше в нем лежал) конфликтует с множеством
#   других классов с таким же именем при релоуде кода
class ValidateContract
  include Dry::Monads[:result]

  def call(input:, contract:)
    contract.new.call(input).to_monad
            .fmap(&:to_h)
            .or { |res| Failure(error_key: :invalid_params, errors: res.errors.to_h) }
  end
end
