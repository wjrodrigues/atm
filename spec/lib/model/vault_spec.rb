# frozen_string_literal: true

require './lib/model/vault'
require './spec/spec_helper'

RSpec.describe Vault do
  describe 'constants' do
    it { expect(described_class::INDEX).to eq({ ten: 10, twenty: 20, fifty: 50, hundred: 100 }) }
    it { expect(described_class::INDEX).to be_frozen }
  end

  describe '#update!' do
    context 'when some notes are updated' do
      it 'returns updated vault' do
        vault = described_class.new
        expected = {
          ten: 0,
          twenty: 10,
          fifty: 0,
          hundred: 3
        }

        vault.update!(twenty: 10, hundred: 3)

        expect(vault.summary).to eq(expected)
      end
    end
  end
end
