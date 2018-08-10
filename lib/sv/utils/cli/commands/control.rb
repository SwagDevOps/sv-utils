# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../commands'

module Sv::Utils::CLI::Commands
  # Command to enable/disable service.
  #
  # Sample of use:
  #
  # ```sh
  # bin/svctl enable ssh
  # bin/svctl disable shutdown --no-auto-start
  # bin/svctl enable httpd -c /etc/sv-utils.yml
  # ```
  class Control < Sv::Utils::CLI::Command::Configurable
    # @return [String]
    attr_reader :action

    # @return [String]
    attr_reader :service

    class << self
      # @return [Array<Symbol>]
      def actions
        Sv::Utils::Control.actions
      end

      protected

      def options
        super.merge(
          ['--mode=MODE', 'Mode'] => ->(c, v) { c.options[:mode] = v },
          ['--[no-]auto-start', 'Autostart service'] => lambda do |c, v|
            c.options[:auto_start] = v
          end
        )
      end
    end

    def parser
      super.tap do |parser|
        parser.banner = [
          parser.banner.gsub(/\[options\]$/, '').strip,
          "{#{self.class.actions.join('|')}}",
          '{SERVICE}',
          '[options]'
        ].join(' ')
      end
    end

    def setup
      super
      validate!.tap do
        @action = arguments.fetch(0)
        @service = arguments.fetch(1)

        options[:auto_start] = true unless options.key?(:auto_start)
      end
    end

    def call
      control.call(action, service, innercall_params)
      $stdout.puts(message)
    rescue StandardError => e
      raise(e) unless e.class.name =~ /^Errno::/

      warn(e)
      exit(e.class.const_get(:Errno))
    end

    # @return [String]
    def message
      s = "#{service}: #{action}d"

      return s unless action.to_sym == :enable

      "#{s} %<h>s" % {
        h: { auto_start: !!options[:auto_start] }
      }
    end

    protected

    # @return [Hash{Symbol => Object}]
    def innercall_params
      {
        auto_start: options[:auto_start],
        futils: options[:mode] || control.params[:futils]
      }
    end

    # @return [Sv::Utils::Control]
    def control(params = {})
      Sv::Utils::Control.new(config, params)
    end

    # Validate arguments.
    #
    # @return [self]
    def validate!
      self.class.actions.map(&:to_s).tap do |actions|
        unless arguments.size == 2 and actions.include?(arguments[0])
          {
            true => "invalid argument: #{arguments[0]}",
            false => 'missing required arguments'
          }.tap { |messages| warn(messages[arguments.size == 2]) }
          exit(Errno::EINVAL::Errno)
        end
      end

      self
    end
  end
end
