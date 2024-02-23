# frozen_string_literal: true

require './spec/spec_helper'
require './lib/dto/withdraw'

require 'json'
require 'date'

RSpec.describe DTO::Withdraw do
  describe '#payload' do
    context 'when param is valid' do
      it 'returns hash', :timecop do
        expected = { action: 'withdraw', value: 100, date_time: DateTime.now }

        params = {
          saque: {
            valor: 100,
            horario: DateTime.now.to_s
          }
        }.to_json

        withdraw = described_class.new(params: JSON.parse(params))

        expect(withdraw.payload.to_h).to eq(expected)
      end
    end

    context 'when param is invalid' do
      it 'returns hash with default values', :timecop do
        expected = { action: 'withdraw', value: 0, date_time: DateTime.now }

        params = {
          saque: {
            valor: 0
          }
        }.to_json

        withdrawer = described_class.new(params: JSON.parse(params))

        expect(withdrawer.payload.to_h).to eq(expected)
      end
    end
  end
end
