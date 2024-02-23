# frozen_string_literal: true

require './spec/spec_helper'
require './lib/model/operation'

require 'date'

RSpec.describe Operation do
  describe 'constants' do
    it { expect(described_class::WITHDRAW).to eq(:withdraw) }
    it { expect(described_class::KINDS).to eq(%i[withdraw]) }
    it { expect(described_class::KINDS).to be_frozen }
  end

  describe '#new' do
    context 'when valid kind' do
      it 'returns instance', :timecop do
        date_time = DateTime.now
        value = 30
        kind = described_class::WITHDRAW

        operation = described_class.new(kind:, value:, date_time:)

        expect(operation.kind).to eq(kind)
        expect(operation.value).to eq(value)
        expect(operation.date_time).to eq(date_time)
      end
    end

    context 'when invalid kind' do
      it 'raise error' do
        expect { described_class.new(kind: :any, value: 30, date_time: DateTime.now) }.to raise_error('invalid kind')
      end
    end
  end
end
