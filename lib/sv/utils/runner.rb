# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../utils'

module Sv::Utils
  # Service (sv) runner, starts a service.
  class Runner < Util
    # @return [Array<Strin>]
    attr_reader :command

    # @param [Array] command
    # @param [Hash|Sv::Utils::Config] config
    # @param [Hash] options
    def initialize(command, config, options = {})
      @command = command.to_a.map(&:to_s)
      super(config, options)
    end

    def params
      user    = options[:user] || config.fetch('user')
      command = config.fetch('command').map(&:to_s).map do |v|
        v % {
          user: user,
        }
      end

      {
        user: user,
        command: command.map(&:to_s)
      }
    end

    def to_s
      cmd = Shellwords.join(params.fetch(:command) + command)

      "#{cmd} 2>&1"
    end
  end
end
