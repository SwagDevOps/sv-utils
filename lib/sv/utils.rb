# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

# rubocop:disable Style/Documentation

module Sv
  module Utils
    {
      VERSION: 'version',
      Config: 'config',
      Configurable: 'configurable',
      Util: 'util',
      SUID: 'suid',
      Shell: 'shell',
      DSL: 'dsl',
      Service: 'service',
      Loggerd: 'loggerd',
      CLI: 'cli',
      Control: 'control',
      Concern: 'concern',
      Empty: 'empty'
    }.each { |k, v| autoload(k, "#{__dir__}/utils/#{v}") }
  end
end

module Sv::Utils
  class << self
    protected

    # @return [Boolean]
    def bundled?
      [%w[gems.rb gems.locked], %w[Gemfile Gemfile.lock]]
        .map { |m| Dir.glob("#{__dir__}/../#{m}").size >= 2 }
        .include?(true)
    end

    # @see https://bundler.io/man/bundle-install.1.html
    #
    # @return [Boolean]
    def standalone?
      standalone_setupfile.file?
    end

    # Load standalone setup if present
    #
    # @return [Boolean]
    def standalone!
      # noinspection RubyResolve
      standalone?.tap { |b| require standalone_setupfile if b }
    end

    # @api private
    #
    # @return [Pathname]
    def standalone_setupfile
      Pathname.new("#{__dir__}/../bundle/bundler/setup.rb")
    end
  end

  unless standalone!
    if bundled?
      require 'bundler/setup'

      if Gem::Specification.find_all_by_name('kamaze-project').any?
        require 'kamaze/project/core_ext/pp'
      end
    end
  end
end

# rubocop:enable Style/Documentation
