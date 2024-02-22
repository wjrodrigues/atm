# frozen_string_literal: true

require_relative '../../../lib/factory/command'
require_relative '../../../lib/response'

RSpec.describe Factory::Command do
  describe '#call' do
    context 'when there is a command to be make' do
      it 'calls provider command' do
        payload = { caixa: {} }
        provider = double('Commands::Provider')

        stub_const('Factory::Command::ACTIONS', { caixa: provider })

        expect(provider).to receive(:call).with(payload)

        response = described_class.call(payload:)

        expect(response).to be_instance_of(Response)
      end
    end

    context 'when there is no command to be make' do
      it 'does not call the provider command' do
        payload = { any: {} }
        provider = double('Commands::Provider')

        stub_const('Factory::Command::ACTIONS', { caixa: provider })

        expect(provider).not_to receive(:call)

        response = described_class.call(payload:)

        expect(response.error).to eq('invalid command')
      end
    end
  end
end
