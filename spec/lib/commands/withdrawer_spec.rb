# frozen_string_literal: true

require './lib/commands/withdrawer'

require 'date'

RSpec.describe Commands::Withdrawer do
  describe '#call' do
    context 'when withdrawal is requested' do
      it 'returns 2 notes of twenty', :timecop do
        atm = ATM.instance(create: true)
        atm.update(payload: { ten: 1, twenty: 3, fifty: 0, hundred: 0 }, availability: true)

        expected = {
          ten: 0,
          twenty: 2,
          fifty: 0,
          hundred: 0,
          availability: true,
          errors: []
        }

        response = described_class.call(payload: { date_time: DateTime.now, value: 30 }, atm:)

        expect(response.result).to eq(expected)
      end

      it 'returns 1 note of ten and 1 of fifty', :timecop do
        atm = ATM.instance(create: true)
        atm.update(payload: { ten: 4, twenty: 0, fifty: 2, hundred: 0 }, availability: true)

        expected = {
          ten: 1,
          twenty: 0,
          fifty: 1,
          hundred: 0,
          availability: true,
          errors: []
        }

        response = described_class.call(payload: { date_time: DateTime.now, value: 80 }, atm:)

        expect(response.result).to eq(expected)
      end

      it 'returns 2 notes of ten and 2 of twenty', :timecop do
        atm = ATM.instance(create: true)
        atm.update(payload: { ten: 3, twenty: 3, fifty: 3, hundred: 3 }, availability: true)

        expected = {
          ten: 2,
          twenty: 2,
          fifty: 3,
          hundred: 3,
          availability: true,
          errors: []
        }

        response = described_class.call(payload: { date_time: DateTime.now, value: 30 }, atm:)

        expect(response.result).to eq(expected)
      end

      it 'returns 2 notes of ten, 2 of twenty and 2 fifty', :timecop do
        atm = ATM.instance(create: true)
        atm.update(payload: { ten: 3, twenty: 3, fifty: 3, hundred: 3 }, availability: true)

        expected = {
          ten: 2,
          twenty: 2,
          fifty: 2,
          hundred: 3,
          availability: true,
          errors: []
        }

        response = described_class.call(payload: { date_time: DateTime.now, value: 80 }, atm:)

        expect(response.result).to eq(expected)
      end

      it 'returns 2 notes of fifty and 2 of hundred', :timecop do
        atm = ATM.instance(create: true)
        atm.update(payload: { ten: 3, twenty: 3, fifty: 3, hundred: 3 }, availability: true)

        expected = {
          ten: 3,
          twenty: 3,
          fifty: 2,
          hundred: 2,
          availability: true,
          errors: []
        }

        response = described_class.call(payload: { date_time: DateTime.now, value: 150 }, atm:)

        expect(response.result).to eq(expected)
      end
    end

    context 'when there is no atm' do
      it 'returns summary with error', :timecop do
        atm = ATM.instance(create: true)

        expected = { errors: ['caixa-inexistente'] }

        response = described_class.call(payload: { date_time: DateTime.now, value: 30 }, atm:)

        expect(response.result).to eq(expected)
      end
    end

    context 'when does not have enough notes' do
      it 'returns summary with error', :timecop do
        atm = ATM.instance(create: true)
        atm.update(payload: { ten: 0, twenty: 0, fifty: 0, hundred: 3 }, availability: true)

        expected = {
          ten: 0,
          twenty: 0,
          fifty: 0,
          hundred: 3,
          availability: true,
          errors: ['valor-indisponivel']
        }

        response = described_class.call(payload: { date_time: DateTime.now, value: 30 }, atm:)

        expect(response.result).to eq(expected)
      end
    end

    context 'when ATM is not available' do
      it 'returns summary with error', :timecop do
        atm = ATM.instance(create: true)
        atm.update(payload: { ten: 0, twenty: 0, fifty: 0, hundred: 3 }, availability: false)

        expected = {
          ten: 0,
          twenty: 0,
          fifty: 0,
          hundred: 3,
          availability: false,
          errors: ['caixa-indisponivel']
        }

        response = described_class.call(payload: { date_time: DateTime.now, value: 30 }, atm:)

        expect(response.result).to eq(expected)
      end
    end

    context 'when double withdrawal' do
      it 'returns summary with error', :timecop do
        atm = ATM.instance(create: true)
        atm.update(payload: { ten: 3, twenty: 3, fifty: 3, hundred: 3 }, availability: true)

        expected = {
          ten: 2,
          twenty: 2,
          fifty: 3,
          hundred: 3,
          availability: true,
          errors: ['saque-duplicado']
        }
        aki
        described_class.call(payload: { date_time: DateTime.now, value: 30 }, atm:)
        response = described_class.call(payload: { date_time: DateTime.now, value: 30 }, atm:)

        expect(response.result).to eq(expected)
      end
    end
  end
end
