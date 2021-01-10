# frozen_string_literal: true

# Copyright (C) 3017-2021 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../utils'

# Provides shell methods
class Sv::Utils::Shell < Sv::Utils::Configurable
  autoload(:Shellwords, 'shellwords')

  # @formatter:off
  {
    Command: 'command',
    Result: 'result',
    Error: 'exceptions',
    ExitStatusError: 'exceptions',
  }.each { |k, v| autoload(k, "#{__dir__}/shell/#{v}") }
  # @formatter:on

  (@mutex_sh = Mutex.new).tap do
    class << self
      protected

      attr_accessor :mutex_sh
    end
  end

  # @return [Result]
  #
  # @raise [ExitStatusError]
  def sh(*params)
    self.class.__send__(:mutex_sh).synchronize do
      Command.new(params).tap do |command|
        warn(command.to_s) if verbose?

        system(*command).tap do |b|
          return Result.new($CHILD_STATUS).tap do |result|
            raise ExitStatusError.new(command, result) unless b
          end
        end
      end
    end
  end

  def verbose?
    options.key?('verbose') ? options['verbose'] : config['verbose']
  end

  protected

  def warn(message)
    # rubocop:disable Style/StderrPuts
    $stderr.puts(message)
    # rubocop:enable Style/StderrPuts
  end
end
