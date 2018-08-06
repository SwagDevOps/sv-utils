# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../utils'

# Provides DSL.
#
# Sample of use:
#
# ```ruby
# require 'sv/utils'
#
# self.extend(Sv::Utils::DSL)
# ```
module Sv::Utils::DSL
  include Sv::Utils::Concern::Env

  singleton_class.include(self)

  # Configure form given filepath.
  #
  # @param [String] filepath
  # @return [self]
  #
  # @see Sv::Utils::Config
  def configure(filepath = nil)
    @config = Sv::Utils::Config.new(filepath).freeze

    self
  end

  # @return [Config]
  def config
    configure if @config.nil?

    @config
  end

  # Prepare a command starting service.
  #
  # @param [Array] command
  # @param [Hash] options
  # @return [Sv::Utils::Service]
  def service(command, options = {})
    Sv::Utils::Service.new(command, config, options)
  end

  # Prepare a command starting ``svlogd``.
  #
  # @return [Sv::Utils::Loggerd]
  def loggerd(*args)
    args.last.tap do |params|
      return Sv::Utils::Loggerd
             .new(args.size == 1 ? nil : args.fetch(0), config, params)
    end
  end

  # @see Sv::Utils::SUID#change_user
  def change_user(*args, &block)
    Sv::Utils::SUID.change_user(*args, &block)
  end
end
