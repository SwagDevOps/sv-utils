# frozen_string_literal: true

# Copyright (C) 2017-2021 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../utils'

autoload :Pathname, 'pathname'
autoload :FileUtils, 'fileutils'

module Sv::Utils
  # Service (sv) logger, starts logger.
  class Loggerd < Configurable::Command
    # @param [Array|String|Object] command
    # @param [Hash|Sv::Utils::Config] config
    # @param [Hash] options
    def initialize(command, config, options = {})
      super

      @command = nil if command.nil?
      @options = options.clone.freeze
    end

    # Get service name (log target).
    #
    # @return [String]
    def service
      return options[:service] if options[:service]

      ARGV.fetch(0).tap do |fp|
        return Pathname.new(fp).realpath.join('../..').basename.to_path
      end
    end

    # @return [String]
    def log_dir
      config.fetch('log_dir') % {
        service: service
      }
    end

    def params
      super.merge(service: service, log_dir: log_dir).tap do |params|
        params[:command] = command if command
      end
    end

    def call
      make_logdir
      super
    end

    # Create log dir and fix owner & mode.
    def make_logdir
      FileUtils.tap do |utils|
        utils.mkdir_p(params.fetch(:log_dir))
        utils.chown(*[:user, :group, :log_dir].map { |k| params.fetch(k).to_s })
        utils.chmod(0o700, params.fetch(:log_dir))
      end
    end
  end
end
