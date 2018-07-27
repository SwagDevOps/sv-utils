# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../utils'

# Command Line Interface (CLI)
module Sv::Utils::CLI
  autoload :Command, "#{__dir__}/cli/command"
  autoload :Runner, "#{__dir__}/cli/runner"
end
