# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../configurable'
autoload :Shellwords, 'shellwords'

module Sv::Utils
  # Almost a command retrieved from config.
  #
  # @abstract# Almost a command retrieved from config.
  #
  # @abstract
  class Configurable::Command < Configurable
    # Get params used for command construction.
    #
    # Params are (mostly) a composition between config and options.
    # At least, ``command`` and ``user`` SHOULD be defined.
    #
    # @see #to_s
    # @return [Hash{Symbol => Object}]
    def params
      {
        user: options[:user] || config['user'] || :root,
        command: config['command'].to_a.map(&:to_s),
      }
    end

    # @return [Array]
    def to_a
      params.fetch(:command)
    end

    # String representation, is a command line.
    #
    # @return [String]
    def to_s
      Shellwords.join(self.to_a)
    end

    # Denote call will run in a privileged mode.
    #
    # @return [Boolean]
    def privileged?
      config['privileged'] == true
    end

    def call
      suid.change_user(params.fetch(:user)) if privileged?
      exec(self.to_s)
    end

    protected

    # @return [Sv::Utils::SUID]
    def suid
      Sv::Utils::SUID
    end
  end
end
