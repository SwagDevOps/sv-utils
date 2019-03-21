# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../utils'

# Provides shell methods
module Sv::Utils::Shell
  singleton_class.include(self)

  # @formatter:off
  {
    Command: 'command',
  }.each { |k, v| autoload(k, "#{__dir__}/shell/#{v}") }
  # @formatter:on

  class << self
    def sh(*params)
      Command.new(params).tap do |command|
        return self.system(*command)
      end
    end

    protected

    # @param [Command] command
    #
    # @raise [RuntimeError]
    #
    # @todo Raise e better error
    # @todo Provide exit status with raised error
    def system(*command)
      Kernel.system(*command) || lambda do
        raise args.inspect
      end.call
    end
  end
end
