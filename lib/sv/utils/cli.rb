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
  {
    Command: 'command',
    Commands: 'commands',
  }.each { |k, v| autoload(k, "#{__dir__}/cli/#{v}") }

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
    # @raise [NameError]
    #
    # @param [String|Symbol] name
    # @return [Sv::Utils::CLI::Command]
    def fetch(name)
      inflector.classify(name).yield_self do |klass_name|
        Sv::Utils::CLI::Commands.const_get(klass_name)
      end
    end

    protected

    # @api private
    #
    # @return [Dry::Inflkector]
    def inflector
      Dry::Inflector.new
    end
  end
end
