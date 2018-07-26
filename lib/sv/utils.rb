# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

# rubocop:disable Style/Documentation

module Sv
  module Utils
    autoload :VERSION, "#{__dir__}/utils/version"
    autoload :Config, "#{__dir__}/utils/config"
    autoload :Util, "#{__dir__}/utils/util"
    autoload :SUID, "#{__dir__}/utils/suid"
    autoload :DSL, "#{__dir__}/utils/dsl"
    autoload :Runner, "#{__dir__}/utils/runner"
    autoload :Logger, "#{__dir__}/utils/logger"
    autoload :Concern, "#{__dir__}/utils/concern"
  end
end

# rubocop:enable Style/Documentation
