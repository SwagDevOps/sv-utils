# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../utils'
require 'dry/inflector'

# Almost a command retrieved from config.
#
# @abstract
class Sv::Utils::Configurable
  # @return [Hash]
  attr_reader :config

  # @return [Hash]
  attr_reader :options

  autoload :Command, "#{__dir__}/configurable/command"

  # @param [Hash|Sv::Utils::Config] config
  # @param [Hash] options
  def initialize(config, options = {})
    @config = config[root_key].clone.freeze
    @options = options.clone.freeze
  end

  # Get params.
  #
  # @return [Hash{Symbol => Object}]
  def params
    {}
  end

  # @return [String]
  def root_key
    inflector = Dry::Inflector.new

    self.class.name.split('::')
        .map { |part| inflector.underscore(part) }.last
  end
end
