# frozen_string_literal: true

module DTO
  class Provide
    attr_accessor :payload

    Structure = Struct.new(:action, :availability, :ten, :twenty, :fifty, :hundred, keyword_init: true)

    def initialize(params: {})
      make(params)
    end

    private

    def make(params)
      values = params['caixa'] || {}

      bills = values['notas'] || {}

      self.payload = Structure.new(
        action: 'provide',
        availability: values.fetch('caixaDisponivel', false),
        ten: bills.fetch('notasDez', 0),
        twenty: bills.fetch('notasVinte', 0),
        fifty: bills.fetch('notasCinquenta', 0),
        hundred: bills.fetch('notasCem', 0)
      )
    end
  end
end
