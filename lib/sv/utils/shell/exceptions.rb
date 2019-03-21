# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../shell'

# @abstract
class Sv::Utils::Shell::Error < StandardError
  # @return [String]
  attr_reader :command

  autoload :Shellwords, 'shellwords'

  # @param [Array<String>|String] command
  def initialize(command)
    self.command = command
  end

  # @return [String]
  def to_s
    "\"#{command}\""
  end

  protected

  # @param [Array<String>|String] command
  def command=(command)
    @command = command.is_a?(Array) ? Shellwords.join(command) : command
  end
end

# Error used when exitstatus is non zero.
class Sv::Utils::Shell::ExitStatusError < Sv::Utils::Shell::Error
  # @return [Process::Status|Object|nil]
  attr_reader :result

  # @param [Array<String>|String] command
  # @param [Process::Status|Object|nil] result
  def initialize(command, result = nil)
    super(command)

    self.result = result unless result.nil?
  end

  # @return [String]
  def to_s
    return super if result.nil?

    "#{super} exited with status: #{result.exitstatus}"
  end

  protected

  # @raise [TypeError]
  # @param [Process::Status|Object] result
  def result=(result)
    unless result.respond_to?(:exitstatus)
      raise TypeError, "#{result.class} must respond to: exitstatus"
    end

    @result = result
  end
end
