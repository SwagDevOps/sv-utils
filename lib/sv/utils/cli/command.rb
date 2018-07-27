# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../cli'
require 'sys/proc'
autoload :OptionParser, 'optparse'

# Command Line Interface (CLI)
# @abstract
class Sv::Utils::CLI::Command
  attr_reader :arguments

  attr_reader :options

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

    yield(self) if block_given?
  end

  # Set progname
  #
  # @param [String] progname
  def progname=(progname)
    Sys::Proc.progname = progname
    @progname = progname
  end

  # Get version.
  #
  # @return [Sv::Utils::VERSION]
  def version(full = false)
    Sv::Utils::VERSION.tap do |version|
      return version unless full
      return ["#{self.progname} #{version}",
              nil,
              version.license_header].join("\n")
    end
  end

  def call
    exit(0)
  end

  protected

  attr_reader :argv

  attr_writer :options

  # @param [Array] argv
  # @return [self]
  def parse!(argv = ARGV)
    parser.parse!(argv.clone)

    self
  end

  # @return [OptionParser]
  def parser
    OptionParser.new do |opts|
      opts.on('-v', '--version', 'Display the version and exit') do
        $stdout.puts(version(true))
        exit
      end

      opts.on('-h', '--help', 'Display this screen and exit') do
        $stdout.print(opts)
        exit
      end
    end
  end
end
