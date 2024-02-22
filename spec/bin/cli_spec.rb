# frozen_string_literal: true

require './bin/cli'
require './lib/response'
require './bin/display/cli'
require './lib/dto/provider'

require 'json'

RSpec.describe CLI do
  describe 'constants ' do
    it { expect(described_class::MSG_START).to eq("Digite 'fim' para sair, ou insira um comando") }
  end

  describe '#start ' do
    context "when input is 'fim'" do
      it 'ends program' do
        factory = double('factory')
        display = Display::CLI.new

        expect(display).to receive(:write).with(described_class::MSG_START)
        expect(display).to receive(:read).and_return('fim')
        expect(display).to receive(:close).and_return(true)
        expect(display).not_to receive(:clear)
        expect(factory).not_to receive(:call)

        described_class.start(display:, factory:)
      end
    end

    context 'when command to end app' do
      it 'shows end of message app' do
        display = Display::CLI.new
        factory = double('factory')

        expect(display).to receive(:write).with(described_class::MSG_START).twice
        expect(display).to receive(:read).and_raise(Interrupt)
        expect(display).to receive(:clear)
        expect(display).to receive(:read).and_return('fim')
        expect(display).to receive(:close).and_return(true)
        expect(factory).not_to receive(:call)

        described_class.start(display:, factory:)
      end
    end

    context 'when input is JSON valid' do
      it 'calls the application factory' do
        display = Display::CLI.new
        factory = double('factory')
        response = Response.new(result: {})
        presenter = Presenter::Provider.new(payload: {})

        raw_json = '{"name": "any"}'

        expect(display).to receive(:write).with(described_class::MSG_START)
        expect(display).to receive(:read).and_return(raw_json)
        expect(factory).to receive(:call).with(payload: DTO::Provider::Structure).and_return(response)
        expect(display).to receive(:write).with(presenter.summary(format: :json))
        expect(display).to receive(:read).and_return('fim')
        expect(display).to receive(:close).and_return(true)

        CLI.start(display:, factory:)
      end
    end

    context 'when input is JSON invalid' do
      it 'shows message error' do
        display = Display::CLI.new
        factory = double('factory')

        expect(display).to receive(:write).with(described_class::MSG_START)
        expect(display).to receive(:read).and_return('')
        expect(display).to receive(:write).with('Dados inválidos')
        expect(display).to receive(:read).and_return('fim')
        expect(display).to receive(:close).and_return(true)
        expect(factory).not_to receive(:call)

        CLI.start(display:, factory:)
      end
    end
  end
end
