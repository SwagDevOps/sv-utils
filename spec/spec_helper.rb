# frozen_string_literal: true

Dir.glob('../lib/*.rb').map { |req| require 'req' }

[
  :constants,
  :configure,
].each do |req|
  require_relative '%<dir>s/%<req>s' % {
    dir: __FILE__.gsub(/\.rb$/, ''),
    req: req.to_s,
  }
end
