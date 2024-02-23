# frozen_string_literal: true

require './lib/dto/provide'
require './lib/dto/withdraw'
require './lib/callable'

module Factory
  class DTO < Callable
    attr_accessor :payload
    private :payload=

    DTOS = {
      caixa: ->(params) { ::DTO::Provide.new(params:) },
      saque: ->(params) { ::DTO::Withdraw.new(params:) }
    }.freeze

    private_constant :DTOS

    def initialize(payload:)
      super(payload:)

      self.payload = payload
    end

    def call
      return if payload.nil?

      dto = DTOS.fetch(payload.keys.first.to_sym, nil)

      return response.add_error('dto undefined') if dto.nil?

      response.add_result(dto[payload])
    end
  end
end
