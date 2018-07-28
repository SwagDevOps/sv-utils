# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../commands'
autoload :Pathname, 'pathname'

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

  # Get contents, indexed by filepath.
  #
  # @return [Hash{Pathname => String}]
  def contents
    arguments.map { |fp| [fp, fp.read] }.to_h
  end

  # Eval files from ``arguments`` with ``DSL``.
  #
  # @param [Object] context
  def call
    contents.each do |fp, content|
      empty_binding.tap do |b|
        b.__send__(:eval, "self.extend(#{DSL})")
        b.local_variable_set(:__dir__, fp.dirname.to_path)
        b.__send__(:eval, content, fp.to_path)
      end
    end
  end

  # @return [Array<Pathname>]
  def arguments
    super.map { |arg| Pathname.new(arg) }
  end
end
