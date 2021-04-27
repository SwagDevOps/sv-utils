# frozen_string_literal: true

# Copyright (C) 2017-2021 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

# noinspection RubyClassModuleNamingConvention
unless Object.const_defined?(:Sv)
  # Module (root namespace)
  module Sv
  end
end

# Module namespace
module Sv::Utils
  {
    VERSION: 'version',
    Bundleable: 'bundleable',
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

  include(Bundleable)
end
