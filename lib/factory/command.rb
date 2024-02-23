# frozen_string_literal: true

require './lib/commands/provider'
require './lib/commands/withdrawer'
require './lib/callable'

module Factory
  class Command < Callable
    attr_accessor :payload
    private :payload=

    ACTIONS = {
      provide: Commands::Provider,
      withdraw: Commands::Withdrawer
    }.freeze

    def initialize(payload:)
      super(payload:)

      return if payload.nil?

      self.payload = payload
    end

    def call
      return if payload.nil?

      action = ACTIONS.fetch(payload.action.to_sym, nil)

      return response.add_error('invalid command') if action.nil?

      action.call(payload:)
    end
  end
end
