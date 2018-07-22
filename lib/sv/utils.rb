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
  autoload :Config, "#{__dir__}/utils/config"

  # @param [String] filepath
  def configure(filepath = nil)
    @config = Config.new(filepath).freeze

    self
  end

  # @return [Config]
  def config
    configure if @config.nil?

    @config
  end

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
    params = params_log(options)

    # Create log dir and fix owner & mode
    FileUtils.tap do |utils|
      utils.mkdir_p(params.fetch(:log_dir))
      utils.chown(*[:user, :group, :log_dir].map { |k| params.fetch(k) })
      utils.chmod(0o700, params.fetch(:log_dir))
    end

    command_log(options).tap { |cmd| exec(cmd) }
  end

  protected

  # rubocop:disable Metrics/MethodLength

  def params_log(options = {}) # rubocop:disable Metrics/AbcSize
    config  = self.config.fetch('log')
    from    = options[:from] || self.config.from
    service = Pathname.new(from).realpath.join('../..').basename.to_path
    user    = options[:user] || config.fetch('user')
    group   = options[:group] || config.fetch('group')
    log_dir = config.fetch('dir') % { service: service }
    command = config.fetch('command').map(&:to_s).map do |v|
      v % {
        user: user,
        dir: log_dir
      }
    end

    {
      user: user,
      group: group,
      service: service,
      log_dir: log_dir,
      command: command.map(&:to_s)
    }
  end

  def params_run(options = {})
    config  = self.config.fetch('run')
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

  # rubocop:enable Metrics/MethodLength

  # Get logging command.
  #
  # @param [Hash] options
  # @return [String]
  def command_log(options = {})
    Shellwords.join(params_log(options).fetch(:command))
  end

  # @param [Array<String>] command
  # @param [Hash] options
  # @return [String]
  def command_run(command, options = {})
    cmd = Shellwords.join(params_run(options).fetch(:command) + command)

    "#{cmd} 2>&1"
  end

  singleton_class.include(self)
end
