# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

$LOAD_PATH.unshift(__dir__)

self.singleton_class.__send__(:define_method, :locked?) do
  Dir.chdir("#{__dir__}/..") do
    [['gems.rb', 'gems.locked'], ['Gemfile', 'Gemfile.lock']]
      .map { |m| 2 == Dir.glob(m).size }
      .include?(true)
  end
end

if locked?
  require 'rubygems'
  require 'bundler/setup'

  if Gem::Specification.find_all_by_name('kamaze-project').any?
    require 'kamaze/project/core_ext/pp'
  end
end
