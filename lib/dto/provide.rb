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

      notes = values['notas'] || {}

      self.payload = Structure.new(
        action: 'provide',
        availability: values.fetch('caixaDisponivel', false),
        ten: notes.fetch('notasDez', 0),
        twenty: notes.fetch('notasVinte', 0),
        fifty: notes.fetch('notasCinquenta', 0),
        hundred: notes.fetch('notasCem', 0)
      )
    end
  end
end
