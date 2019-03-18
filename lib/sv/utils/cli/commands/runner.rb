# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../commands'

# Runner provides DSL evaluation.
#
# Sample of use:
#
# ```
# #!/usr/bin/env ruby
# # frozen_string_literal: true
#
# require 'sv/utils/cli'
#
# Sv::Utils::CLI::Runner.new(['httpd.rb']).call(self)
# ```
#
# Script file (``httpd.rb``) executed by the runner:
#
# ```
# #!/usr/bin/env svrun
#
# service(['/sbin/httpd', '-F']).call
# ```
class Sv::Utils::CLI::Commands::Runner < Sv::Utils::CLI::Command
  DSL = Sv::Utils::DSL

  autoload(:Pathname, 'pathname')

  # Eval files from ``arguments`` with ``DSL``.
  #
  # @return [self]
  def call
    arguments.each do |fp|
      empty_binding.tap do |b|
        b.__send__(:eval, "self.extend(#{DSL})")
        b.local_variable_set(:__dir__, fp.dirname.to_path)
        b.__send__(:eval, fp.read, fp.to_path)
      end
    end

    self
  end

  # @return [Array<Pathname>]
  def arguments
    (options[:multiple] ? super : [super[0]].compact)
      .map { |arg| Pathname.new(arg) }
  end

  class << self
    def options
      {
        ['-m', '--[no-]multiple', 'Run on multiple inputs'] => lambda do |c, v|
          c.__send__(:options)[:multiple] = v
        end
      }.tap { |opts| super.merge(opts) }
    end
  end
end
