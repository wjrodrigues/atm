# frozen_string_literal: true

require 'json'

module Presenter
  class Provider
    attr_accessor :payload

    def initialize(payload:)
      self.payload = payload
    end

    def summary(format: :hash)
      value = {
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

      return JSON.pretty_generate(value) if format == :json

      value
    end
  end
end
