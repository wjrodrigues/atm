# frozen_string_literal: true

require 'json'

module Bin
  class CLI
    OPEN = /[{"']/
    CLOSE = /[}"']/
    BREAK_LINE = "\n"
    END_APP = 'fim'
    MSG_START = "Digite 'fim' para sair, ou insira um comando"

    private_constant :CLOSE, :OPEN, :BREAK_LINE, :END_APP

    class << self
      def start(factory:, kernel: Kernel)
        command = ''

        kernel.puts(MSG_START)

        loop do
          line = kernel.gets

          kernel.exit && return if line.chomp == END_APP

          next if line == BREAK_LINE

          command += line

          if command.scan(OPEN).size == command.scan(CLOSE).size
            factory.call(JSON.parse(command))
            command = ''
          end
        rescue Interrupt
          command = ''

          kernel.clear_screen

          kernel.puts(MSG_START)
        rescue JSON::ParserError
          kernel.puts('Dados inválidos')
        end
      end
    end
  end
end
