# frozen_string_literal: true

require './spec/spec_helper'
require './lib/dto/provide'

require 'json'

RSpec.describe DTO::Provide do
  describe '#payload' do
    context 'when param is valid' do
      it 'returns hash' do
        expected = { action: 'provide', ten: 5, twenty: 5, fifty: 5, hundred: 5, availability: false }

        params = {
          caixa: {
            caixaDisponivel: false,
            notas: {
              notasDez: 5,
              notasVinte: 5,
              notasCinquenta: 5,
              notasCem: 5
            }
          }
        }.to_json

        provide = described_class.new(params: JSON.parse(params))

        expect(provide.payload.to_h).to eq(expected)
      end
    end

    context 'when param is invalid' do
      it 'returns hash with default values' do
        expected = { action: 'provide', ten: 0, twenty: 0, fifty: 0, hundred: 0, availability: false }

        params = {
          caixaDisponivel: false,
          notas: {
            notasDez: 5,
            notasVinte: 5,
            notasCinquenta: 5,
            notasCem: 5
          }
        }.to_json

        provide = described_class.new(params: JSON.parse(params))

        expect(provide.payload.to_h).to eq(expected)
      end
    end
  end
end
