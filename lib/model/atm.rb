# frozen_string_literal: true

require_relative 'vault'
require_relative 'operation'

class ATM
  MIN_OPERATION_INTERVAL = 600 # seconds

  attr_accessor :availability, :vault, :errors, :default, :operations

  private_class_method :new

  private :availability=, :vault=, :errors=, :default=, :operations=

  def self.instance(create: false)
    return @instance if !create && defined?(@instance)

    @instance = new
  end

  def initialize
    self.availability = false
    self.vault = Vault.new
    self.errors = []
    self.default = true
    self.operations = []
  end

  def summary = vault.summary.merge(availability:, errors:)

  def update(payload:, availability:)
    self.default = false

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

  def add_operation(operation)
    return unless operation.is_a?(Operation)

    operations << operation
  end

  def operation_exists?(operation)
    operation = operations.find do |o|
      next if operation.value != o.value

      (operation.date_time.to_time.to_i - o.date_time.to_time.to_i).abs > MIN_OPERATION_INTERVAL
    end

    !operation.nil?
  end
end
