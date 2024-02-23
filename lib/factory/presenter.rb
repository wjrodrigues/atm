# frozen_string_literal: true

require_relative '../presenter/provide'
require_relative '../presenter/withdraw'
require_relative '../callable'

module Factory
  class Presenter < Callable
    attr_accessor :payload, :action
    private :payload=, :action=

    PRESENTERS = {
      provide: ->(payload) { ::Presenter::Provide.new(payload:) },
      withdraw: ->(payload) { ::Presenter::Withdraw.new(payload:) }
    }.freeze

    private_constant :PRESENTERS

    def initialize(action:, payload:)
      super(action:, payload:)

      self.payload = payload
      self.action = action.to_sym
    end

    def call
      return if payload.nil? || action.nil?

      presenter = PRESENTERS.fetch(action, nil)

      return response.add_error('presenter undefined') if presenter.nil?

      presenter[payload]
    end
  end
end
