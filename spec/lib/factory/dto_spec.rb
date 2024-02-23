# frozen_string_literal: true

require './spec/spec_helper'
require './lib/factory/dto'
require './lib/dto/provide'
require './lib/dto/withdraw'
require './lib/response'

require 'json'

RSpec.describe Factory::DTO do
  describe '#call' do
    context 'when there is a dto to be make' do
      it 'calls provide DTO' do
        payload = { caixa: {} }

        response = described_class.call(payload:)

        expect(response.result).to be_instance_of(DTO::Provide)
      end

      it 'calls withdraw DTO' do
        payload = { saque: {} }

        response = described_class.call(payload:)

        expect(response.result).to be_instance_of(DTO::Withdraw)
      end
    end

    context 'when there is no dto to be make' do
      it 'does not call any factory dto' do
        payload = { any: {} }

        response = described_class.call(payload:)

        expect(response).not_to be_ok
        expect(response.error).to eq('dto undefined')
      end
    end
  end
end
