# frozen_string_literal: true

# Copyright (C) 2017-2021 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../sv/utils'

# rubocop:disable Style/Documentation

# noinspection RubyClassModuleNamingConvention
unless Object.const_defined?(:Sv)
  module Sv
  end
end

module Sv::Utils
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

module Sv::Utils
  class << self
    protected

    # @return [Boolean]
    def bundled?
      [%w[gems.rb gems.locked], %w[Gemfile Gemfile.lock]]
        .map { |m| m.map { |fname| bundle_base.join(fname).file? }.keep_if { |v| v == true }.size >= 2 }
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

    # @return [Pathname]
    def bundle_base
      Pathname.new(__dir__).join('..', '..')
    end

    # @api private
    #
    # @return [Pathname]
    def standalone_setupfile
      bundle_base.join('bundle', 'bundler', 'setup.rb')
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
