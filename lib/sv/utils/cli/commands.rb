# frozen_string_literal: true

# Copyright (C) 2017-2021 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../cli'

# Commands.
module Sv::Utils::CLI::Commands
  autoload :Runner, "#{__dir__}/commands/runner"
  autoload :Control, "#{__dir__}/commands/control"
end
