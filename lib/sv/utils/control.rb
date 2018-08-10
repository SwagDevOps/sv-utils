# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../utils'
autoload :Pathname, 'pathname'

module Sv::Utils
  # Control do enable disable services.
  class Control < Configurable
    autoload :Actionable, "#{__dir__}/control/actionable"

    # Enable service by given name.
    #
    # @param [String|Symbol] name
    # @param [Hash{Symbol => Object}] params
    def enable(name, params = {})
      call(:enable, [name].push(params))
    end

    # Disable service by given name.
    #
    # @param [String|Symbol] name
    # @param [Hash{Symbol => Object}] params
    def disable(name, params = {})
      call(:enable, [name].push(params))
    end

    # @param [String|Symbol] action
    def call(action, *args)
      params = {}
      if args.last.is_a?(Hash)
        params = args.last
        args = args[0...-1]
      end

      actions.fetch(action.to_sym)
             .call(*args.push(self.params.merge(params)))
    end

    class << self
      # @return [Array<Symbol>]
      def actions
        Actionable.actions.keys
      end
    end

    # @raise [KeyError]
    # @return [Hash{Symbol => Object}]
    #
    # @todo Improve paths retrieval
    def params
      {
        futils: config['futils'],
        paths: [
          Pathname.new(config['paths'].to_a.fetch(0)),
          lambda do
            # prioritize SVDIR over configuration
            (ENV['SVDIR'] || config['paths'].to_a[1] || ENV.fetch('SVDIR'))
              .tap { |dir| return Pathname.new(dir) }
          end.call
        ].freeze,
      }
    end

    # @return [Hash{Symbol => Method}]
    def actions
      Actionable.actions
    end
  end
end
