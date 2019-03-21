# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../shell'

# Capture result.
class Sv::Utils::Shell::Result
  # @return [String]
  attr_reader :stdout

  # @return [String]
  attr_reader :stderr

  # @return [Process::Status]
  attr_reader :status

  # @param [Process::Status] status
  # @param [String] stdout
  # @param [String] stderr
  #
  # @raise [TypeError]
  # @see #status
  def initialize(status, stdout: nil, stderr: nil)
    self.status = status
    @stdout = stdout
    @stderr = stderr
  end

  # @return [Boolean]
  def success?
    exitstatus.zero?
  end

  # @return [Boolean]
  def failure?
    !success?
  end

  # @return [Integer]
  def exitstatus
    status.exitstatus
  end

  protected

  # @raise [TypeError]
  # @param [Process::Status] status
  def status=(status)
    unless status.respond_to?(:exitstatus)
      raise TypeError, "#{status.class} must respond to: exitstatus"
    end

    @status = status
  end
end
