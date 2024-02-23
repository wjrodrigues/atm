# frozen_string_literal: true

require 'json'
require './lib/presenter/provide'
require './bin/display/cli'

class CLI
  OPEN = /[{"]/
  CLOSE = /[}"]/
  BREAK_LINE = "\n"
  END_APP = 'fim'
  MSG_START = "Digite 'fim' para sair, ou insira um comando"

  private_constant :CLOSE, :OPEN, :BREAK_LINE, :END_APP
  private_class_method :new

  def self.start(factory_command:, factory_dto:, factory_presenter:, display: Display::CLI.new)
    new(factory_command:, factory_dto:, factory_presenter:, display:).start
  end

  attr_accessor :display, :command, :factory_command, :factory_dto, :factory_presenter
  private :display=, :factory_command=, :factory_dto=, :factory_presenter=

  def initialize(display:, factory_command:, factory_dto:, factory_presenter:)
    self.display = display
    self.command = ''
    self.factory_command = factory_command
    self.factory_dto = factory_dto
    self.factory_presenter = factory_presenter
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
    dto = build_dto!
    command_resp = factory_command.call(payload: dto.payload)
    presenter = factory_presenter.call(action: dto.payload.action, payload: command_resp.result)

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

  def build_dto!
    json = JSON.parse(self.command)

    dto = factory_dto.call(payload: json)

    raise unless dto.ok?

    dto.result
  end
end
