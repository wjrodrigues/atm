# frozen_string_literal: true

require './spec/spec_helper'
require './lib/factory/presenter'
require './lib/presenter/provide'
require './lib/presenter/withdraw'

RSpec.describe Factory::Presenter do
  describe '#call' do
    context 'when there is a presenter to be make' do
      it 'calls provide presenter' do
        response = described_class.call(action: :provide, payload: {})

        expect(response).to be_instance_of(Presenter::Provide)
      end

      it 'calls Withdraw presenter' do
        response = described_class.call(action: :withdraw, payload: {})

        expect(response).to be_instance_of(Presenter::Withdraw)
      end
    end

    context 'when there is no presenter to be make' do
      it 'does not call any factory presenter' do
        response = described_class.call(action: :any, payload: {})

        expect(response).not_to be_ok
        expect(response.error).to eq('presenter undefined')
      end
    end
  end
end
