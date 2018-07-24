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
    autoload :Config, "#{__dir__}/utils/config"
    autoload :Util, "#{__dir__}/utils/util"
    autoload :SUID, "#{__dir__}/utils/suid"
    autoload :Runner, "#{__dir__}/utils/runner"
    autoload :Logger, "#{__dir__}/utils/logger"
    autoload :Concern, "#{__dir__}/utils/concern"
  end
end

# rubocop:enable Style/Documentation

# Utils for Sv
module Sv::Utils
  include Concern::Env

  singleton_class.include(self)

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

  # Initialize a ``Runner``.
  #
  # @param [Array] command
  # @param [Hash] options
  # @return [Runner]
  def runner(command, options = {})
    Runner.new(command, config, options)
  end

  # Initialize a logger.
  #
  # @param [Hash] options
  # @return [Logger]
  def logger(options = {})
    Logger.new(config, options)
  end

  # @see Sv::Utils::SUID#change_user
  def change_user(*args, &block)
    SUID.change_user(*args, &block)
  end
end
