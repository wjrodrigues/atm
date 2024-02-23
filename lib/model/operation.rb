# frozen_string_literal: true

require 'date'

class Operation
  attr_accessor :kind, :value, :date_time

  private :kind=, :value=, :date_time=

  WITHDRAW = :withdraw
  KINDS = [WITHDRAW].freeze
  ERROR_KIND = 'invalid kind'

  private_constant :ERROR_KIND

  def initialize(kind:, value:, date_time:)
    raise StandardError, ERROR_KIND unless KINDS.include?(kind)

    self.kind = kind
    self.value = value
    self.date_time = date_time
  end
end
