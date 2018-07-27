# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../cli'
autoload :Pathname, 'pathname'

module Sv::Utils::CLI
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
  class Runner < Command
    DSL = Sv::Utils::DSL

    # Get contents, indexed by filepath.
    #
    # @return [Hash{Pathname => String}]
    def contents
      arguments.map { |fp| [fp, fp.read] }.to_h.freeze
    end

    # Eval files from ``arguments`` with ``DSL``.
    #
    # @param [Object] context
    def call(context)
      contents.each do |fp, content|
        context.extend(DSL) unless context.is_a?(DSL)

        context.__send__(:eval, content, TOPLEVEL_BINDING, fp.to_path)
      end
    end

    # @return [Array<Pathname>]
    def arguments
      super.map { |arg| Pathname.new(arg) }
    end
  end
end
