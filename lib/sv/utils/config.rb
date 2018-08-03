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
  attr_accessor :file

  # @param [String] file
  def initialize(file = nil)
    @file = Pathname.new(file || self.class.filepath)

    load_file(Pathname.new(__dir__).join('config.yml'))
    return if file.nil? and !self.file&.readable?
    load_file(self.file)
  end

  def to_path
    self.file.to_path
  end

  class << self
    # Get config filename (without extension).
    #
    # @return [String]
    def filename
      self.name.split('::')[0..1].map(&:downcase).join('-')
    end

    # Get default filepath.
    #
    # @return [String] ``/etc/sv-utils.yml``
    def filepath
      Pathname.new('/etc').join("#{filename}.yml").to_path
    end

    protected

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

  protected

  # @param [String] filepath
  # @return [Hash]
  def load_file(filepath)
    YAML.safe_load(Pathname.new(filepath).read).to_h.tap do |loaded|
      self.class
          .__send__(:deep_merge, self.to_h, loaded)
          .each { |k, v| self[k] = v }
    end
  end
end
