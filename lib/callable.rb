# frozen_string_literal: true

require_relative 'response'

class Callable
  attr_accessor :response

  private_class_method :new

  def self.call(...)
    new(...).call
  end

  def initialize(...)
    self.response = Response.new
  end
end
