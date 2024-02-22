# frozen_string_literal: true

require './spec/spec_helper'
require './lib/dto/provider'

require 'json'

RSpec.describe DTO::Provider do
  describe '#payload' do
    context 'when param is valid' do
      it 'returns hash' do
        expected = { action: 'caixa', ten: 5, twenty: 5, fifty: 5, hundred: 5, availability: false }

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

        provider = described_class.new(params: JSON.parse(params))

        expect(provider.payload.to_h).to eq(expected)
      end
    end

    context 'when param is invalid' do
      it 'returns hash with default values' do
        expected = { action: 'caixa', ten: 0, twenty: 0, fifty: 0, hundred: 0, availability: false }

        params = {
          caixaDisponivel: false,
          notas: {
            notasDez: 5,
            notasVinte: 5,
            notasCinquenta: 5,
            notasCem: 5
          }
        }.to_json

        provider = described_class.new(params: JSON.parse(params))

        expect(provider.payload.to_h).to eq(expected)
      end
    end
  end
end
