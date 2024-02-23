# frozen_string_literal: true

class Vault
  attr_accessor :notes

  INDEX = { ten: 10, twenty: 20, fifty: 50, hundred: 100 }.freeze

  private :notes=, :notes

  def initialize
    self.notes = {
      ten: 0,
      twenty: 0,
      fifty: 0,
      hundred: 0
    }
  end

  def update!(notes)
    %i[ten twenty fifty hundred].each do |v|
      self.notes[v] = notes[v] unless notes[v].nil?
    end
  end

  def summary = notes.clone
end
