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
  # Get callled ``from``.
  #
  # Given ``from`` or
  # determined using ``ARGV[0]`` (if file) then ``caller_locations``.
  #
  # @return [Pathname]
  attr_reader :from

  # @param [String] from
  #
  # @note Unless a YAML is given,
  #       begin to search config at this (``from``) point.
  def initialize(from = nil)
    if self.class.__send__(:yml?, from)
      @from = Pathname.new(from).freeze
      @file = @from
    else
      @from = Pathname.new(from || file_from(caller_locations)).realpath.freeze
      @file = config.freeze
    end

    load_file(Pathname.new(__dir__).join('config.yml'))
    load_file(self.file) if self.file&.readable?
  end

  # Get config file filename.
  #
  # @return [String]
  def filename
    self.class.filename
  end

  # Get filepath for loaded config.
  #
  # @return [String|nil]
  def filepath
    self.file&.to_path
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

    # Denote given file path seems to be a YAML file.
    #
    # @param [String|Pathname|nil] filepath
    # @return [Boolean]
    def yml?(filepath)
      return false if filepath.nil?

      filepath.to_s.split('.').keep_if { |s| !s.empty? }.tap do |parts|
        return [
          parts.size >= 2,
          ['yml', 'yaml'].include?(parts.last),
        ].uniq == [true]
      end
    end

    alias yaml? yml?
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
    nil
  end

  protected

  # @return [Pathname|nil]
  attr_accessor :file

  # @param [String] filepath
  # @return [Hash]
  def load_file(filepath)
    YAML.safe_load(Pathname.new(filepath).read).to_h.tap do |loaded|
      self.class
          .__send__(:deep_merge, self.to_h, loaded)
          .each { |k, v| self[k] = v }
    end
  end

  # Get file automagically
  #
  # @param [Array] locations
  # @return [Pathname]
  def file_from(locations = caller_locations)
    origin = nil
    ARGV[0]&.tap do |fp|
      origin = Pathname.new(fp).realpath if File.file?(fp)
    end

    Pathname.new(origin || locations.last.path).realpath
  end
end
