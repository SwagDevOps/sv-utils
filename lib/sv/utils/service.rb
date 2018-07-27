# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../utils'

module Sv::Utils
  # Service (sv) runner, starts a service.
  class Service < Configurable::Command
    # @return [Array<String>]
    attr_reader :command

    # @param [Array] command
    # @param [Hash|Sv::Utils::Config] config
    # @param [Hash] options
    def initialize(command, config, options = {})
      @command = command.to_a.map(&:to_s).freeze

      super(config, options)
    end

    def params
      command = super.fetch(:command).map do |v|
        v % { user: super.fetch(:user) }
      end

      super.merge(command: command)
    end

    def to_a
      super + command
    end

    def to_s
      "#{super} 2>&1"
    end
  end
end
