# frozen_string_literal: true
# vim: ai ts=2 sts=2 et sw=2 ft=ruby
# rubocop:disable all

Gem::Specification.new do |s|
  s.name        = "sv-utils"
  s.version     = "0.0.4"
  s.date        = "2021-05-21"
  s.summary     = "Runit (sv) utils."
  s.description = "Utils for sv (runit)."

  s.licenses    = ["GPL-3.0"]
  s.authors     = ["Dimitri Arrigoni"]
  s.email       = "dimitri@arrigoni.me"
  s.homepage    = "https://github.com/SwagDevOps/sv-utils"

  s.required_ruby_version = ">= 2.5.0"
  s.require_paths = ["lib"]
  s.bindir        = "bin"
  s.executables   = [
    "svctl",
    "svrun",
  ]
  s.files         = [
    ".yardopts",
    "README.md",
    "bin/svctl",
    "bin/svrun",
    "lib/sv-utils.rb",
    "lib/sv/utils.rb",
    "lib/sv/utils/bundleable.rb",
    "lib/sv/utils/cli.rb",
    "lib/sv/utils/cli/command.rb",
    "lib/sv/utils/cli/command/configurable.rb",
    "lib/sv/utils/cli/commands.rb",
    "lib/sv/utils/cli/commands/control.rb",
    "lib/sv/utils/cli/commands/runner.rb",
    "lib/sv/utils/cli/empty.rb",
    "lib/sv/utils/concern.rb",
    "lib/sv/utils/concern/env.rb",
    "lib/sv/utils/config.rb",
    "lib/sv/utils/configurable.rb",
    "lib/sv/utils/configurable/command.rb",
    "lib/sv/utils/control.rb",
    "lib/sv/utils/control/actionable.rb",
    "lib/sv/utils/dsl.rb",
    "lib/sv/utils/loggerd.rb",
    "lib/sv/utils/service.rb",
    "lib/sv/utils/shell.rb",
    "lib/sv/utils/shell/command.rb",
    "lib/sv/utils/shell/exceptions.rb",
    "lib/sv/utils/shell/result.rb",
    "lib/sv/utils/suid.rb",
    "lib/sv/utils/version.rb",
    "lib/sv/utils/version.yml",
  ]

  s.add_runtime_dependency("dry-inflector", ["~> 0.1"])
  s.add_runtime_dependency("kamaze-version", ["~> 1.0"])
  s.add_runtime_dependency("stibium-bundled", ["~> 0.0.1", ">= 0.0.4"])
  s.add_runtime_dependency("sys-proc", ["~> 1.1", ">= 1.1.2"])
end

# Local Variables:
# mode: ruby
# End:
