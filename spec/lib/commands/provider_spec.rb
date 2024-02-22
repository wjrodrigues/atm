# frozen_string_literal: true

require './lib/response'
require './lib/commands/provider'

RSpec.describe Commands::Provider do
  describe '#call' do
    context 'when it is updated but it is unavailable' do
      it 'does not update and returns summary' do
        atm = ATM.instance(create: true)

        expected = {
          ten: 0,
          twenty: 0,
          fifty: 0,
          hundred: 0,
          availability: false,
          errors: []
        }

        expect(atm).to receive(:add_error).with('caixa-em-uso').and_call_original
        expect(atm.vault).not_to receive(:update!)

        response = described_class.call(payload: { twenty: 10, hundred: 3 }, atm:)

        expect(response.result).to eq(expected)
      end
    end

    context 'when it is updated many times but not available' do
      it 'does not update and returns summary with error' do
        atm = ATM.instance(create: true)

        expected = {
          ten: 0,
          twenty: 0,
          fifty: 0,
          hundred: 0,
          availability: false,
          errors: ['caixa-em-uso']
        }

        expect(atm).to receive(:add_error).with('caixa-em-uso').and_call_original.twice
        expect(atm.vault).not_to receive(:update!)

        described_class.call(payload: { twenty: 10, hundred: 3 }, atm:)
        response = described_class.call(payload: { twenty: 10, hundred: 3 }, atm:)

        expect(response.result).to eq(expected)
      end
    end

    context 'when it is updated and available' do
      it 'returns updated summary' do
        atm = ATM.instance(create: true)

        expected = {
          ten: 0,
          twenty: 12,
          fifty: 0,
          hundred: 13,
          availability: true,
          errors: []
        }

        described_class.call(payload: { twenty: 10, hundred: 3 }, atm:)

        response = described_class.call(payload: { twenty: 12, hundred: 13, availability: true }, atm:)

        expect(response.result).to eq(expected)
      end
    end

    context 'when raise error' do
      it 'returns summary' do
        atm = ATM.instance(create: true)

        expected = {
          ten: 0,
          twenty: 0,
          fifty: 0,
          hundred: 0,
          availability: false,
          errors: []
        }

        expect(atm).to receive(:availability!).and_raise('any')

        response = described_class.call(payload: { twenty: 12, hundred: 13, availability: true }, atm:)

        expect(response.result).to eq(expected)
      end
    end
  end
end
