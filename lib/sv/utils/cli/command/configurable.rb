# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../command'

class Sv::Utils::CLI::Command
  # Provides config.
  #
  # Config attribute + command option.
  #
  # @abstract
  class Configurable < self
    Config = Sv::Utils::Config

    # @return [Sv::Utils::Config]
    attr_reader :config

    def setup
      @options = { config: Config.filepath }.merge(options)
      @config = Config.new(@options[:config])
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
end
