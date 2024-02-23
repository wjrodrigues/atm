# frozen_string_literal: true

require 'date'

module DTO
  class Withdraw
    attr_accessor :payload

    Structure = Struct.new(:action, :value, :date_time)

    def initialize(params: {})
      make(params)
    end

    private

    def make(params)
      values = params['saque'] || {}

      date_time = DateTime.parse(values['horario'] || DateTime.now.to_s)

      self.payload = Structure.new(
        action: 'withdraw',
        value: values.fetch('valor', 0),
        date_time:
      )
    end
  end
end
