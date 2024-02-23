# frozen_string_literal: true

require './spec/spec_helper'
require './lib/presenter/provide'
require 'json'

RSpec.describe Presenter::Provide do
  describe '#summary' do
    context 'when summary is requested' do
      it 'returns formatted summary' do
        payload = {
          ten: 0,
          twenty: 0,
          fifty: 0,
          hundred: 0,
          availability: false,
          errors: []
        }

        expected = {
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

        presenter = described_class.new(payload:)

        expect(presenter.summary).to eq(expected)
        expect(presenter.summary(format: :json)).to eq(JSON.pretty_generate(expected))
      end
    end
  end
end
