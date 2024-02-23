# frozen_string_literal: true

require_relative 'bin/cli'
require_relative 'lib/factory/command'
require_relative 'lib/factory/dto'
require_relative 'lib/factory/presenter'

CLI.start(factory_command: Factory::Command, factory_dto: Factory::DTO, factory_presenter: Factory::Presenter)
