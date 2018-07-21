# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

# rubocop:disable Style/Documentation

module Sv
  module Utils
    autoload :VERSION, "#{__dir__}/utils/version"
  end
end

# rubocop:enable Style/Documentation

autoload :Pathname, 'pathname'
autoload :Shellwords, 'shellwords'
autoload :FileUtils, 'fileutils'

# Utils for Sv
module Sv::Utils
  # Run command
  #
  # @param [Array<String>] command
  def run(command, options = {})
    command_run(command, options).tap { |cmd| exec(cmd) }
  end

  # Start logging.
  #
  # @param [Hash] options
  def log(options = {})
    command_log(options).tap { |cmd| exec(cmd) }
  end

  protected

  # Get logging command.
  #
  # @param [Hash] options
  def command_log(options = {}) # rubocop:disable Metrics/MethodLength
    # Variables used for logging
    service = Pathname.new(options.fetch(:from))
                      .realpath.join('../..').basename

    log_dir = "/var/log/runit/#{service}"
    user, group = [options[:user], options[:group]]
                  .map { |v| v || :root }.map(&:to_s)

    # Create log dir and fix owner & mode
    FileUtils.tap do |utils|
      utils.mkdir_p(log_dir)
      utils.chown(user, group, log_dir)
      utils.chmod(0o700, log_dir)
    end

    ['/sbin/chpst', '-u', user, '/sbin/svlogd', '-tt', log_dir]
  end

  # @param [Array<String>] command
  def command_run(command, options = {})
    command = ['exec', '/sbin/chpst',
               '-u', (options[:user] || :root).to_s, '--'].push(*command)

    command = Shellwords.join(command.map(&:to_s))

    "#{command} 2>&1"
  end

  singleton_class.include(self)
end
