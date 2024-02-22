# frozen_string_literal: true

require_relative 'bin/cli'
require_relative 'lib/factory/command'

CLI.start(factory: Factory::Command)
