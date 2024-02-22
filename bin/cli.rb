# frozen_string_literal: true

require 'json'
require './lib/presenter/provider'
require './bin/display/cli'
require './lib/dto/provider'

class CLI
  OPEN = /[{"']/
  CLOSE = /[}"']/
  BREAK_LINE = "\n"
  END_APP = 'fim'
  MSG_START = "Digite 'fim' para sair, ou insira um comando"

  private_constant :CLOSE, :OPEN, :BREAK_LINE, :END_APP
  private_class_method :new

  def self.start(factory:, display: Display::CLI.new)
    new(factory:, display:).start
  end

  attr_accessor :display, :command, :factory
  private :display=, :factory=

  def initialize(display:, factory:)
    self.display = display
    self.command = ''
    self.factory = factory
  end

  def start
    orientation

    loop do
      line = display.read

      display.close && return if line.chomp == END_APP

      next if line == BREAK_LINE

      self.command += line

      if command_ready?
        response
        clear_command
      end
    rescue Interrupt
      display.clear

      clear_command
      orientation
    end
  end

  private

  def response
    provider = DTO::Provider.new(params: JSON.parse(self.command))

    resp = factory.call(payload: provider.payload)

    presenter = Presenter::Provider.new(payload: resp.result)

    display.write(presenter.summary(format: :json))
  rescue JSON::ParserError, StandardError
    display.write('Dados inválidos')
  end

  def command_ready? = self.command.scan(OPEN).size == self.command.scan(CLOSE).size

  def clear_command = self.command = ''

  def orientation
    clear_command
    display.write(MSG_START)
  end
end
