# frozen_string_literal: true

# Copyright (C) 3017-2021 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../cli'

require 'sys/proc'
require 'dry/inflector'
autoload :OptionParser, 'optparse'

# Command Line Interface (CLI)
#
# @abstract
class Sv::Utils::CLI::Command
  autoload :Configurable, "#{__dir__}/command/configurable"

  # @return [Array<String>]
  attr_reader :arguments

  # @return [Hash]
  attr_reader :options

  # Get progname.
  #
  # @return [String]
  attr_reader :progname

  # @param [Array] argv
  def initialize(argv = ARGV)
    @options = {}
    self.progname = $PROGRAM_NAME

    argv.tap do |argvc|
      argvc = argvc.to_a.clone
      parse!(argvc)
      @arguments = argvc
    end

    setup

    yield(self) if block_given?
  end

  # Set progname
  #
  # @param [String] progname
  def progname=(progname)
    Pathname.new(progname.to_s).basename.to_s.tap do |name|
      Sys::Proc.progname = name
      @progname = name
    end
  end

  # Get version.
  #
  # @return [Sv::Utils::VERSION|String]
  def version(full = false)
    Sv::Utils::VERSION.tap do |version|
      return version unless full

      return [
        "#{gem_name} #{version}",
        nil,
        version.license_header
      ].join("\n")
    end
  end

  # @return [String]
  def gem_name
    inflector = Dry::Inflector.new

    self.class.name.split('::')[0..1].map { |part| inflector.underscore(part) }.join('-')
  end

  def call
    exit(0)
  end

  protected

  # @type [Hash]
  attr_writer :options

  # Inheritnce purpose.
  def setup
    # noinspection RubyUnnecessaryReturnStatement
    return
  end

  def usage(retcode = 0)
    (retcode.zero? ? $stdout : $stderr).tap do |io|
      io.write(parser)

      exit(retcode)
    end
  end

  # @param [Array] argv
  # @return [self]
  def parse!(argv)
    parser.parse!(argv)
    self
  rescue OptionParser::InvalidOption => e
    warn(e)
    exit(Errno::EINVAL::Errno)
  end

  # @return [OptionParser]
  def parser
    OptionParser.new do |opts|
      self.class.__send__(:options).sort_by do |row|
        row[0]
      end.to_h.each do |k, v|
        opts.on(*k) { |c| v.call(self, c) }
      end
    end
  end

  # @return [Binding]
  def empty_binding
    Sv::Utils::CLI::Empty.binding
  end

  class << self
    protected

    # Get options, used to populate ``parser``.
    #
    # @return [Hash{Array<String> => Proc}]
    def options # rubocop:disable Metrics/MethodLength
      {
        ['--version', 'Display the version and exit'] =>
          lambda do |c, _|
            $stdout.puts(c.__send__(:version, true))
            exit(0)
          end,
        ['--help', 'Display this screen and exit'] =>
          lambda do |c, _|
            c.__send__(:usage)
            exit(0)
          end,
      }
    end
  end
end
