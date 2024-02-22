# frozen_string_literal: true

require_relative '../../lib/response'
require_relative '../../lib/callable'

RSpec.describe Callable do
  class MockCallable < Callable
    def call
      response
    end
  end

  describe '#call' do
    context 'when called' do
      it 'returns response' do
        response = MockCallable.call

        expect(response).to be_instance_of(Response)
      end
    end
  end
end
