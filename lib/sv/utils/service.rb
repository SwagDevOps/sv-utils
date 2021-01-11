# frozen_string_literal: true

# Copyright (C) 2017-2021 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../utils'
autoload :Shellwords, 'shellwords'

# Service (sv) runner, starts a service.
class Sv::Utils::Service < Sv::Utils::Configurable::Command
  def to_a
    super + command.map do |v|
      v.to_s % params.reject { |k| k == :command }
    end
  end

  def to_s
    "#{super} 2>&1"
  end
end
