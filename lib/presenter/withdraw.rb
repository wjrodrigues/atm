# frozen_string_literal: true

require 'json'

module Presenter
  class Withdraw
    attr_accessor :payload

    ERROR_ATM_NOT_EXISTS = 'caixa-inexistente'
    private_constant :ERROR_ATM_NOT_EXISTS

    def initialize(payload:)
      self.payload = payload
    end

    def summary(format: :hash)
      value = build_data

      value[:caixa] = {} if payload[:errors].include?(ERROR_ATM_NOT_EXISTS)

      return JSON.pretty_generate(value) if format == :json

      value
    end

    private

    def build_data
      {
        caixa: {
          caixaDisponivel: payload[:availability],
          notas: {
            notasDez: payload[:ten],
            notasVinte: payload[:twenty],
            notasCinquenta: payload[:fifty],
            notasCem: payload[:hundred]
          }
        },
        errors: payload[:errors]
      }
    end
  end
end
