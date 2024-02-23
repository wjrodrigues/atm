# frozen_string_literal: true

require './lib/model/atm'
require './lib/callable'

module Commands
  class Withdrawer < Callable
    attr_accessor :payload, :atm, :operation

    private :operation=, :operation

    ERROR_ATM_NOT_EXISTS = 'caixa-inexistente'
    ERROR_UNAVAILABLE_VALUE = 'valor-indisponivel'
    ERROR_ATM_UNAVAILABLE = 'caixa-indisponivel'
    ERROR_WITHDRAW_DUPLICATED = 'saque-duplicado'

    def initialize(payload:, atm: ATM.instance)
      super(payload:)

      self.payload = payload
      self.atm = atm
    end

    def call
      return atm_not_exists if atm.default
      return summary unless authorized?

      vault_summary = atm.summary
      updated_summary = calculate(vault_summary, payload[:value])

      return unavailable_value unless updated_summary

      update(updated_summary)

      summary
    end

    private

    def authorized?
      return atm_unavailable && false unless atm.availability

      binding.irb
      withdraw_duplicated && false if atm.operation_exists?(new_operation)

      true
    end

    def atm_not_exists
      atm.add_error(ERROR_ATM_NOT_EXISTS)

      result = summary.result.slice(:errors)
      summary.add_result(result)
    end

    def unavailable_value
      atm.add_error(ERROR_UNAVAILABLE_VALUE)

      summary
    end

    def atm_unavailable
      atm.add_error(ERROR_ATM_UNAVAILABLE)

      summary
    end

    def withdraw_duplicated
      atm.add_error(ERROR_WITHDRAW_DUPLICATED)

      summary
    end

    def new_operation
      self.operation = Operation.new(
        kind: Operation::WITHDRAW, value: payload[:value], date_time: payload[:date_time]
      )
    end

    def calculate(vault_summary, value)
      %i[hundred fifty twenty ten].each do |key|
        next if vault_summary[key].zero? || value <= vault_summary[key]

        rest = value % Vault::INDEX[key]

        next if rest == value

        subtract = value / Vault::INDEX[key]

        next if vault_summary[key] < subtract

        vault_summary[key] -= subtract

        value = rest
      end

      return false if value.positive?

      vault_summary
    end

    def update(updated_summary)
      atm.update(payload: updated_summary, availability: atm.availability)
      atm.add_operation(operation)
    end

    def summary
      return response.add_result(atm.summary) if atm.error?

      response.add_result(atm.summary.merge(errors: []))
    end
  end
end
