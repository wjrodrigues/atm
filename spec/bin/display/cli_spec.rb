# frozen_string_literal: true

require './bin/cli'
require 'json'

RSpec.describe Display::CLI do
  describe '#clear' do
    context 'when to request screen cleaning' do
      it 'calls kernel system' do
        kernel = double('kernel')

        expect(kernel).to receive(:system).with('clear')

        described_class.new(kernel:).clear
      end
    end
  end

  describe '#write' do
    context 'when write on screen' do
      it 'calls kernel puts' do
        kernel = double('kernel')

        expect(kernel).to receive(:puts).with('hi')

        described_class.new(kernel:).write('hi')
      end
    end
  end

  describe '#close' do
    context 'when close screen' do
      it 'calls kernel exit' do
        kernel = double('kernel')

        expect(kernel).to receive(:exit)

        described_class.new(kernel:).close
      end
    end
  end

  describe '#read' do
    context 'when read input' do
      it 'calls kernel gets' do
        kernel = double('kernel')

        expect(kernel).to receive(:gets)

        described_class.new(kernel:).read
      end
    end
  end
end
