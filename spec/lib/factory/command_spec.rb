# frozen_string_literal: true

require './spec/spec_helper'
require './lib/factory/command'
require './lib/response'

RSpec.describe Factory::Command do
  describe '#call' do
    context 'when there is a command to be make' do
      it 'calls provider command' do
        payload = Struct.new(:action).new(action: 'caixa')

        expect_any_instance_of(Commands::Provider).to receive(:call).and_call_original

        response = described_class.call(payload:)

        expect(response).to be_instance_of(Response)
      end

      it 'calls withdrawer command' do
        payload = Struct.new(:action, :date_time, :value).new(action: 'saque', date_time: DateTime.now, value: 0)

        expect_any_instance_of(Commands::Withdrawer).to receive(:call).and_call_original

        response = described_class.call(payload:)

        expect(response).to be_instance_of(Response)
      end
    end

    context 'when there is no command to be make' do
      it 'does not call the provider command' do
        payload = Struct.new(:action).new(action: 'any')

        expect_any_instance_of(Commands::Provider).not_to receive(:call)

        response = described_class.call(payload:)

        expect(response.error).to eq('invalid command')
      end
    end
  end
end
