# frozen_string_literal: true

Dir.glob('../lib/*.rb').map { |req| require 'req' }

if Gem::Specification.find_all_by_name('sys-proc').any?
  require 'sys/proc'

  Sys::Proc.progname = 'rspec'
end

[
  :constants,
  :configure,
].each do |req|
  require_relative '%<dir>s/%<req>s' % {
    dir: __FILE__.gsub(/\.rb$/, ''),
    req: req.to_s,
  }
end

require 'sv/utils'

autoload :Fileutils, 'fileutils'
