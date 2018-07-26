# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
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
    # @param [Hash|Sv::Utils::Config] config
    # @param [Hash] options
    def initialize(config, options = {})
      super

      @options = { from: config.from }.merge(options.clone).freeze
    end

    # rubocop:disable Metrics/MethodLength

    def params
      from    = options.fetch(:from)
      service = Pathname.new(from).realpath.join('../..').basename.to_path
      group   = options[:group] || config.fetch('group')
      log_dir = config.fetch('log_dir') % { service: service }

      super.merge(
        service: service,
        group: group,
        log_dir: log_dir,
        command: super.fetch(:command).map do |v|
          v % {
            user: super.fetch(:user),
            log_dir: log_dir
          }
        end
      )
    end

    # rubocop:enable Metrics/MethodLength

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