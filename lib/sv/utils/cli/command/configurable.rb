# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../command'

# Provides config.
#
# Config attribute + command option.
#
# @abstract
class Sv::Utils::CLI::Command::Configurable < Sv::Utils::CLI::Command
  # @return [Sv::Utils::Config]
  attr_reader :config

  def setup
    @options = { config: nil }.merge(options)
    self.config = @options[:config]
  end

  protected

  # Set config from given filepath.
  #
  # @param [String|nil|Pathname] filepath
  def config=(filepath)
    @config = Sv::Utils::Config.new(filepath)
  rescue StandardError => e
    raise(e) unless e.class.name =~ /^Errno::/

    warn(e)
    exit(e.class.const_get(:Errno))
  end

  class << self
    protected

    def options
      super.merge(
        ['-cFILE', '--config=FILE', 'Config filepath'] => lambda do |c, v|
          c.options[:config] = v
        end
      ).sort.to_h
    end
  end
end
