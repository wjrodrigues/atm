# frozen_string_literal: true

require_relative '../../bin/cli'
require 'json'

RSpec.describe Bin::CLI do
  describe 'constants ' do
    it { expect(described_class::MSG_START).to eq("Digite 'fim' para sair, ou insira um comando") }
  end

  describe '#start ' do
    context "when input is 'fim'" do
      it 'ends program' do
        kernel = double('kernel')
        factory = double('factory')

        expect(kernel).to receive(:puts).with(described_class::MSG_START)
        expect(kernel).to receive(:gets).and_return('fim')
        expect(kernel).to receive(:exit).and_return(true)
        expect(kernel).not_to receive(:clear_screen)
        expect(factory).not_to receive(:call)

        Bin::CLI.start(kernel:, factory:)
      end
    end

    context 'when command to end app' do
      it 'shows end of message app' do
        kernel = double('kernel')
        factory = double('factory')

        expect(kernel).to receive(:puts).with(described_class::MSG_START).twice
        expect(kernel).to receive(:gets).and_raise(Interrupt)
        expect(kernel).to receive(:gets).and_return('fim')
        expect(kernel).to receive(:clear_screen)
        expect(kernel).to receive(:exit).and_return(true)
        expect(factory).not_to receive(:call)

        Bin::CLI.start(kernel:, factory:)
      end
    end

    context 'when input is JSON valid' do
      it 'calls the application factory' do
        kernel = double('kernel')
        factory = double('factory')
        raw_json = '{"name": "any"}'

        expect(kernel).to receive(:puts).with(described_class::MSG_START)
        expect(kernel).to receive(:gets).and_return(raw_json)
        expect(kernel).to receive(:gets).and_return('fim')
        expect(kernel).to receive(:exit).and_return(true)
        expect(factory).to receive(:call).with(JSON.parse(raw_json))

        Bin::CLI.start(kernel:, factory:)
      end
    end

    context 'when input is JSON invalid' do
      it 'shows message error' do
        kernel = double('kernel')
        factory = double('factory')

        expect(kernel).to receive(:gets).and_return('')
        expect(kernel).to receive(:gets).and_return('fim')
        expect(kernel).to receive(:exit).and_return(true)
        expect(kernel).to receive(:puts).with(described_class::MSG_START)
        expect(kernel).to receive(:puts).with('Dados inválidos')
        expect(factory).not_to receive(:call)

        Bin::CLI.start(kernel:, factory:)
      end
    end
  end
end
