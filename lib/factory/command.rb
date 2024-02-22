# frozen_string_literal: true

require_relative '../commands/provider'
require_relative '../callable'

module Factory
  class Command < Callable
    attr_accessor :payload
    private :payload=

    ACTIONS = {
      caixa: Commands::Provider
    }.freeze

    def initialize(payload:)
      super(payload:)

      return if payload.empty?

      self.payload = payload
    end

    def call
      return if payload.empty?

      key = payload.keys.first

      action = ACTIONS.fetch(key, nil)

      return response.add_error('invalid command') if action.nil?

      response.add_result(action.call(payload))
    end
  end
end
