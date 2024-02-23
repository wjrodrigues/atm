# frozen_string_literal: true

require './lib/response'
require './lib/commands/provider'

RSpec.describe Commands::Provider do
  describe '#call' do
    context 'when it is not yet available for use' do
      it 'updates and returns summary' do
        atm = ATM.instance(create: true)

        expected = {
          ten: 0,
          twenty: 10,
          fifty: 0,
          hundred: 3,
          availability: false,
          errors: []
        }

        expect(atm).not_to receive(:add_error)
        expect(atm.vault).to receive(:update!).and_call_original

        response = described_class.call(payload: { twenty: 10, hundred: 3 }, atm:)

        expect(response.result).to eq(expected)
      end
    end

    context 'when it is available for use' do
      it 'returns summary with error if update many times' do
        atm = ATM.instance(create: true)

        expected = {
          ten: 0,
          twenty: 0,
          fifty: 0,
          hundred: 0,
          availability: true,
          errors: ['caixa-em-uso']
        }

        expect(atm).to receive(:add_error).with('caixa-em-uso').and_call_original
        expect(atm.vault).to receive(:update!)

        response = described_class.call(payload: { availability: true, twenty: 10, hundred: 3 }, atm:)
        expect(response.result[:errors]).to be_empty

        response = described_class.call(payload: { availability: true, twenty: 10, hundred: 3 }, atm:)
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

        expect(atm).to receive(:update).and_raise('any')

        response = described_class.call(payload: { twenty: 12, hundred: 13, availability: true }, atm:)

        expect(response.result).to eq(expected)
      end
    end
  end
end
