# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../utils'
autoload :Pathname, 'pathname'
require 'yaml'

# Configuration
#
# Configuration file is search recursively.
class Sv::Utils::Config < Hash
  # @return [Pathname]
  attr_reader :from

  # @param [String] from begin to search config at this point.
  def initialize(from = nil)
    @from = Pathname.new(from || file_from(caller_locations)).realpath.freeze
    @file = config.freeze

    load_file(Pathname.new(__dir__).join('config.yml'))
    load_file(self.file) if self.file
  end

  # Get filename for searched config.
  #
  # @return [String]
  def filename
    self.class.name.split('::')[0..1].map(&:downcase).join('-')
  end

  # Get filepath for loaded config.
  #
  # @return [String|nil]
  def filepath
    self.file&.to_path
  end

  class << self
    # @param target [Hash] target **altered** hash
    # @param origin [Hash]
    # @return the modified target hash
    #
    # @note this method does not merge Arrays
    def deep_merge(target, origin)
      target.merge!(origin) do |key, oldval, newval|
        hashable = oldval.is_a?(Hash) and newval.is_a?(Hash)

        newval = deep_merge(oldval, newval) if hashable

        newval
      end
    end
  end

  # @return [Pathname|nil]
  def config
    path = Pathname.new(self.from)
    loop do
      path = path.dirname
      conf = path.join("#{filename}.yml")

      return conf if conf.file? and conf.readable?
      break if path.to_path == '/'
    end

    self
  end

  protected

  # @return [Pathname|nil]
  attr_accessor :file

  # @param [String] filepath
  # @return [Hash]
  def load_file(filepath)
    YAML.safe_load(Pathname.new(filepath).read).to_h.tap do |loaded|
      self.class.deep_merge(self.to_h, loaded).each { |k, v| self[k] = v }
    end
  end

  # Get file automagically
  #
  # @param [Array] locations
  # @return [Pathname]
  def file_from(locations = caller_locations)
    location = locations.last.path

    Pathname.new(location).realpath
  end
end
