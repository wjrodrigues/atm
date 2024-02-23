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
      return update_unavailability unless atm.availability

      atm.add_error(ERROR_IN_USE) if atm.availability

      return update_unavailability(clear: true) unless payload[:availability]

      summary
    rescue StandardError
      # TODO: add error tracking if needed

      summary
    end

    private

    def update_unavailability(clear: false)
      atm.clear_error if clear

      update!

      summary
    end

    def summary
      return response.add_result(atm.summary.merge(errors: [ERROR_IN_USE])) if atm.error?

      response.add_result(atm.summary.merge(errors: []))
    end

    def update!
      atm.update(payload:, availability: payload[:availability])
      atm.clear_error
    end
  end
end
