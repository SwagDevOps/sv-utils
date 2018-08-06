# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../utils'
autoload :Shellwords, 'shellwords'

module Sv::Utils
  # Service (sv) runner, starts a service.
  class Service < Configurable::Command
    # @return [Array<String>]
    attr_reader :command

    # @param [Array|String|Object] command
    # @param [Hash|Sv::Utils::Config] config
    # @param [Hash] options
    def initialize(command, config, options = {})
      unless command.is_a?(Array)
        @command = Shellwords.split(command.to_s)
      end

      @command = command.to_a.map(&:to_s).freeze

      super(config, options)
    end

    def to_a
      super + command.map do |v|
        v.to_s % params.reject { |k| k == :command }
      end
    end

    def to_s
      "#{super} 2>&1"
    end
  end
end
