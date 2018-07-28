# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../utils'
require 'dry/inflector'

# Command Line Interface (CLI)
module Sv::Utils::CLI
  autoload :Command, "#{__dir__}/cli/command"
  autoload :Commands, "#{__dir__}/cli/commands"

  class << self
    # Propagate call to given name command.
    #
    # @param [String|Symbol] name
    # @param [Array] argv
    def call(name, argv = ARGV)
      fetch(name).new(argv.to_a).call
    end

    # Fetch command by given mane.
    #
    # @param [String|Symbol] name
    # @return [Sv::Utils::CLI::Command]
    # @raise [NameError]
    def fetch(name)
      name = Dry::Inflector.new.classify(name)

      Sv::Utils::CLI::Commands.const_get(name)
    end
  end
end
