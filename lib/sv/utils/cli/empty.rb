# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../cli'

# Provides empty binding.
#
# Sample of use:
#
# ```ruby
# Empty.binding.tap do |b|
#   b.local_variable_set(:answer, 42)
#   b.local_variable_set(:home, '127.0.0.1')
#
#   b.eval(content)
# end
# ```
class Sv::Utils::CLI::Empty
  class << self
    # @return [Binding]
    def binding
      super
    end
  end
end
