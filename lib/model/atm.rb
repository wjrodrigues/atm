# frozen_string_literal: true

require_relative 'vault'

class ATM
  attr_accessor :availability, :vault, :errors

  private_class_method :new

  private :availability=, :vault=, :errors=

  def self.instance(create: false)
    return @instance if !create && defined?(@instance)

    @instance = new
  end

  def initialize
    self.availability = false
    self.vault = Vault.new
    self.errors = []
  end

  def summary = vault.summary.merge(availability:, errors:)

  def update(payload:, availability:)
    vault.update!(payload)

    availability!(availability)
  end

  def add_error(err)
    return if err.nil?

    errors << err

    errors.uniq!
  end

  def clear_error = self.errors = []

  def error? = !errors.empty?

  def availability!(value)
    return unless [TrueClass, FalseClass].include?(value.class)

    self.availability = value
  end
end
