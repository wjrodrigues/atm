# frozen_string_literal: true

require './spec/spec_helper'
require './lib/model/atm'
require './lib/model/operation'

require 'date'

RSpec.describe ATM do
  describe '#instance' do
    context 'when instance is created success' do
      it 'returns always the same object' do
        instance_a = described_class.instance
        instance_b = described_class.instance

        expect(instance_a).to eq(instance_b)
      end
    end
  end

  describe '#summary' do
    context 'when is requested' do
      it 'returns hash with vault and availability' do
        instance = described_class.instance(create: true)
        expected = {
          ten: 0,
          twenty: 0,
          fifty: 0,
          hundred: 0,
          availability: false,
          errors: []
        }

        expect(instance.summary).to eq(expected)
      end
    end
  end

  describe '#update' do
    context 'when is it updated' do
      it 'returns hash with vault and availability' do
        instance = described_class.instance(create: true)
        expected = {
          ten: 1,
          twenty: 0,
          fifty: 0,
          hundred: 3,
          availability: true,
          errors: []
        }

        instance.update(payload: { ten: 1, hundred: 3 }, availability: true)

        expect(instance.summary).to eq(expected)
      end

      it 'verifies is default instance' do
        instance = described_class.instance(create: true)

        expect(instance.default).to be_truthy

        instance.update(payload: { ten: 1, hundred: 3 }, availability: true)

        expect(instance.default).to be_falsy
      end
    end
  end

  describe '#error' do
    context 'when error is added' do
      it 'returns error and clear' do
        instance = described_class.instance(create: true)

        instance.add_error('in use')

        expect(instance.error?).to be_truthy
        expect(instance.errors).to eq(['in use'])

        instance.clear_error

        expect(instance.error?).to be_falsy
        expect(instance.errors).to be_empty
      end
    end

    context 'when the same error is added' do
      it 'returns uniq error' do
        instance = described_class.instance(create: true)

        instance.add_error('in use')
        instance.add_error('in use')

        expect(instance.errors).to eq(['in use'])
      end
    end

    context 'when the nil is added' do
      it 'returns errors without nil' do
        instance = described_class.instance(create: true)

        instance.add_error('in use')
        instance.add_error(nil)

        expect(instance.errors).to eq(['in use'])
      end
    end
  end

  describe '#availability!' do
    context 'when availability changes' do
      it 'changes availability' do
        instance = described_class.instance(create: true)

        expect(instance.availability).to be_falsy

        instance.availability!(true)

        expect(instance.availability).to be_truthy

        instance.availability!('false')
        instance.availability!(nil)
      end
    end
  end

  describe '#add_operation' do
    context 'when adding valid operation' do
      it 'adds operation' do
        operation = Operation.new(kind: Operation::WITHDRAW, value: 30, date_time: DateTime.now)
        instance = described_class.instance(create: true)
        instance.add_operation(operation)

        expect(instance.operations).to be_include(operation)
      end
    end

    context 'when adding invalid operation' do
      it 'does not add operation' do
        operation = Object.new
        instance = described_class.instance(create: true)

        expect(instance.add_operation(operation)).to be_falsy
        expect(instance.operations).not_to be_include(operation)
      end
    end
  end

  describe '#operation_exists?' do
    context 'when verify operation exists' do
      it 'returns false if passed 10 minutes', :timecop do
        date_time = DateTime.parse('2023-02-22T08:11:00 -0300')
        operation = Operation.new(kind: Operation::WITHDRAW, value: 30, date_time:)
        instance = described_class.instance(create: true)

        instance.add_operation(Operation.new(kind: Operation::WITHDRAW, value: 30, date_time: Time.now))

        expect(instance.operation_exists?(operation)).to be_falsy
      end

      it 'returns true if not passed 10 minutes', :timecop do
        date_time = DateTime.parse('2023-02-22T08:09:00 -0300')
        operation = Operation.new(kind: Operation::WITHDRAW, value: 30, date_time:)
        instance = described_class.instance(create: true)

        instance.add_operation(Operation.new(kind: Operation::WITHDRAW, value: 30, date_time: Time.now))

        expect(instance.operation_exists?(operation)).to be_truthy
      end

      it 'returns false if value is different', :timecop do
        operation = Operation.new(kind: Operation::WITHDRAW, value: 30, date_time: DateTime.now)
        instance = described_class.instance(create: true)

        instance.add_operation(Operation.new(kind: Operation::WITHDRAW, value: 50, date_time: DateTime.now))

        expect(instance.operation_exists?(operation)).to be_falsy
      end
    end
  end
end
