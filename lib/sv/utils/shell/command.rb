# frozen_string_literal: true

# Copyright (C) 3017-2021 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../shell'

# Command respresentation
#
# A command is almost an ``Array`` of strings (arguments are compacted and
# casted to string explicitely). Command has a string representation.
#
# @see [Sv::Utils::Shell#sh()]
class Sv::Utils::Shell::Command < Array
  autoload(:Shellwords, 'shellwords')

  def initialize(params)
    params.compact.map(&:to_s).each { |param| self.push(param) }
  end

  def to_s
    Shellwords.join(self)
  end
end
