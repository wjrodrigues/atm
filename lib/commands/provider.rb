# frozen_string_literal: true

require './lib/model/atm'
require './lib/callable'

module Commands
  class Provider < Callable
    ERROR_IN_USE = 'caixa-em-uso'

    attr_accessor :payload, :atm

    private_constant :ERROR_IN_USE

    def initialize(payload:, atm: ATM.instance)
      super(payload:)

      self.payload = payload
      self.atm = atm
    end

    def call
      unless available?
        atm.availability!(false)

        summary_tmp = summary

        atm.add_error(ERROR_IN_USE)

        return summary_tmp
      end

      update!

      summary
    rescue StandardError
      # TODO: add error tracking if needed

      summary
    end

    private

    def available? = payload[:availability] == true

    def summary
      return response.add_result(atm.summary) if atm.error?

      response.add_result(atm.summary.merge(errors: []))
    end

    def update!
      atm.availability!(true)
      atm.vault.update!(payload)
      atm.clear_error
    end
  end
end
