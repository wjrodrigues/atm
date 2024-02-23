# frozen_string_literal: true

require './bin/cli'
require './lib/response'
require './bin/display/cli'
require './lib/presenter/provide'
require './lib/dto/provide'

require 'json'

RSpec.describe CLI do
  describe 'constants ' do
    it { expect(described_class::MSG_START).to eq("Digite 'fim' para sair, ou insira um comando") }
  end

  describe '#start ' do
    context "when input is 'fim'" do
      it 'ends program' do
        factory_command = double('factory_command')
        factory_dto = double('factory_dto')
        factory_presenter = double('factory_presenter')
        display = Display::CLI.new

        expect(display).to receive(:write).with(described_class::MSG_START)
        expect(display).to receive(:read).and_return('fim')
        expect(display).to receive(:close).and_return(true)
        expect(display).not_to receive(:clear)
        expect(factory_command).not_to receive(:call)
        expect(factory_dto).not_to receive(:call)
        expect(factory_presenter).not_to receive(:call)

        described_class.start(display:, factory_command:, factory_dto:, factory_presenter:)
      end
    end

    context 'when command to end app' do
      it 'shows end of message app' do
        factory_command = double('factory_command')
        factory_dto = double('factory_dto')
        factory_presenter = double('factory_presenter')
        display = Display::CLI.new

        expect(display).to receive(:write).with(described_class::MSG_START).twice
        expect(display).to receive(:read).and_raise(Interrupt)
        expect(display).to receive(:clear)
        expect(display).to receive(:read).and_return('fim')
        expect(display).to receive(:close).and_return(true)
        expect(factory_command).not_to receive(:call)
        expect(factory_dto).not_to receive(:call)
        expect(factory_presenter).not_to receive(:call)

        described_class.start(display:, factory_command:, factory_dto:, factory_presenter:)
      end
    end

    context 'when input is JSON valid' do
      it 'calls the application factory' do
        factory_command = double('factory_command')
        factory_dto = double('factory_dto')
        factory_presenter = double('factory_presenter')

        display = Display::CLI.new
        presenter = Presenter::Provide.new(payload: {})
        dto = DTO::Provide.new(params: { caixa: {} })

        raw_json = '{"caixa": {}}'

        expect(display).to receive(:write).with(described_class::MSG_START)
        expect(display).to receive(:read).and_return(raw_json)
        expect(factory_dto).to receive(:call).and_return(Response.new(result: dto))
        expect(factory_command).to receive(:call).and_return(Response.new(result: {}))
        expect(factory_presenter).to receive(:call).and_return(presenter)
        expect(display).to receive(:write).with(presenter.summary(format: :json))
        expect(display).to receive(:read).and_return('fim')
        expect(display).to receive(:close).and_return(true)

        CLI.start(display:, factory_command:, factory_dto:, factory_presenter:)
      end
    end

    context 'when input is JSON invalid' do
      it 'shows message error' do
        factory_command = double('factory_command')
        factory_dto = double('factory_dto')
        factory_presenter = double('factory_presenter')
        display = Display::CLI.new

        expect(display).to receive(:write).with(described_class::MSG_START)
        expect(display).to receive(:read).and_return('')
        expect(display).to receive(:write).with('Dados inválidos')
        expect(display).to receive(:read).and_return('fim')
        expect(display).to receive(:close).and_return(true)
        expect(factory_command).not_to receive(:call)
        expect(factory_dto).not_to receive(:call)
        expect(factory_presenter).not_to receive(:call)

        CLI.start(display:, factory_command:, factory_dto:, factory_presenter:)
      end
    end
  end
end
