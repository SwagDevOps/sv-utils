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
  # @return [Hash]
  attr_reader :config

  # @return [Hash]
  attr_reader :options

  # @param [Hash|Sv::Utils::Config] config
  # @param [Hash] options
  def initialize(config, options = {})
    @config = config[root_key]
    @options = options.clone
  end

  # Get params used for command construction.
  #
  # Params are (mostly) a composition between config and options.
  # At least, command SHOULD be defined.
  #
  # @see #to_s
  # @return [Hash{Symbol => Object}]
  def params
    {
      command: config['command'].to_a.map(&:to_s),
    }
  end

  # Strin representation, is a command line.
  #
  # @return [String]
  def to_s
    Shellwords.join(params.fetch(:command))
  end

  def call
    exec(self.to_s)
  end

  # @return [String]
  def root_key
    inflector = Dry::Inflector.new

    self.class.name.split('::')
        .map { |part| inflector.underscore(part) }.last
  end
end
