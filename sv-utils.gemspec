# frozen_string_literal: true
# vim: ai ts=2 sts=2 et sw=2 ft=ruby
# rubocop:disable all

require 'pathname'

Gem::Specification.new do |s|
  s.name        = "sv-utils"
  s.version     = "0.0.1"
  s.date        = "2017-07-21"
  s.summary     = "Runit (sv) utils."
  s.description = "Utils for sv (runit)."

  s.licenses    = ["GPL-3.0"]
  s.authors     = ["Dimitri Arrigoni"]
  s.email       = "dimitri@arrigoni.me"
  s.homepage    = "https://github.com/SwagDevOps/sv-utils"

  # MUST follow the higher required_ruby_version
  # requires version >= 2.3.0 due to safe navigation operator &
  s.required_ruby_version = ">= 2.3.0"
  s.require_paths = ["lib"]
  s.bindir        = "bin"
  s.executables   = Dir.glob("%s/*" % s.bindir)
                       .map { |f| Pathname.new(f) }
                       .keep_if { |f| f.file? and f.executable? }
                       .map { |f| f.basename.to_s }
  s.files = [
    ".yardopts",
    "bin/*",
    "lib/**/*.rb",
    "lib/**/*.yml",
  ].map { |m| Dir.glob(m) }.flatten.sort

  s.add_runtime_dependency("dry-inflector", ["~> 0.1"])
  s.add_runtime_dependency("kamaze-version", ["~> 1.0"])
  s.add_runtime_dependency("sys-proc", [">= 1.1.2", "~> 1.1"])
end

# Local Variables:
# mode: ruby
# End:
