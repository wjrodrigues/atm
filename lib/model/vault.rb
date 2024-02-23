# frozen_string_literal: true

class Vault
  attr_accessor :bills

  INDEX = { ten: 10, twenty: 20, fifty: 50, hundred: 100 }.freeze

  private :bills=, :bills

  def initialize
    self.bills = {
      ten: 0,
      twenty: 0,
      fifty: 0,
      hundred: 0
    }
  end

  def update!(bills)
    %i[ten twenty fifty hundred].each do |v|
      self.bills[v] = bills[v] unless bills[v].nil?
    end
  end

  def summary = bills.clone
end
