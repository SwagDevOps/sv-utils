# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../utils'
require 'dry/inflector'

autoload :Shellwords, 'shellwords'

# @abstract
class Sv::Utils::Util
  SUID = Sv::Utils::SUID

  # @return [Hash]
  attr_reader :config

  # @return [Hash]
  attr_reader :options

  # @param [Hash|Sv::Utils::Config] config
  # @param [Hash] options
  def initialize(config, options = {})
    @config = config[root_key].clone.freeze
    @options = options.clone.freeze
  end

  # Get params used for command construction.
  #
  # Params are (mostly) a composition between config and options.
  # At least, ``command`` and ``user`` SHOULD be defined.
  #
  # @see #to_s
  # @return [Hash{Symbol => Object}]
  def params
    {
      user: options[:user] || config.fetch('user'),
      command: config['command'].to_a.map(&:to_s),
    }
  end

  # String representation, is a command line.
  #
  # @return [String]
  def to_s
    Shellwords.join(params.fetch(:command))
  end

  # Denote call will run in a privileged mode.
  #
  # @return [Boolean]
  def privileged?
    config['privileged'] == true
  end

  def call
    SUID.change_user(params.fetch(:user)) if privileged?
    exec(self.to_s)
  end

  # @return [String]
  def root_key
    inflector = Dry::Inflector.new

    self.class.name.split('::')
        .map { |part| inflector.underscore(part) }.last
  end
end
