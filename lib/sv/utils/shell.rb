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

  autoload(:Shellwords, 'shellwords')
  # @formatter:off
  {
    Command: 'command',
    Result: 'result',
    ExitStatusError: 'exceptions',
  }.each { |k, v| autoload(k, "#{__dir__}/shell/#{v}") }
  # @formatter:on

  (@mutex_sh = Mutex.new).tap do
    class << self
      protected

      attr_accessor :mutex_sh
    end
  end

  class << self
    # @return [Result]
    #
    # @raise [ExitStatusError]
    def sh(*params)
      self.mutex_sh.synchronize do
        # warn(Shellwords.join(command)) if verbose?

        Command.new(params).tap do |command|
          system(*command).tap do |b|
            return Result.new($CHILD_STATUS).tap do |result|
              raise ExitStatusError.new(command, result) unless b
            end
          end
        end
      end
    end
  end
end
