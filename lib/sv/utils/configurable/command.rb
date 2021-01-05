# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../configurable'
autoload :Etc, 'etc'
autoload :Shellwords, 'shellwords'

# Almost a command retrieved from config.
#
# @abstract Almost a command retrieved from config.
#
# @abstract
class Sv::Utils::Configurable::Command < Sv::Utils::Configurable
  # @param [Array<String>, String, nil] command
  # @param [Sv::Utils::Config, Hash] config
  # @param [Hash] options
  #
  # @see #command=
  def initialize(command, config, options = {})
    self.command = command

    super(config, options)
  end

  # Get params used for command construction.
  #
  # Params are (mostly) a composition between config and options.
  # At least, ``command`` and ``user`` SHOULD be defined.
  #
  # ``chdir`` behave as ``Dir.chdir`` argument.
  # @see https://ruby-doc.org/core-2.7.0/Dir.html#method-c-chdir
  #
  # @see #to_s
  # @return [Hash{Symbol => Object}]
  def params # rubocop:disable Metrics/AbcSize
    {
      chdir: options[:chdir] || config['chdir'] || Dir.pwd,
      user: options[:user] || config['user'] || :root,
      group: options[:group] || config['group'], # group will be set from user
      command: config['command'].to_a.map(&:to_s),
    }.tap do |params|
      Etc.getpwnam(params.fetch(:user).to_s).tap do |user|
        params[:group] ||= Etc.getgrgid(user.gid).name
      end
    end
  end

  # @return [Array]
  def to_a
    self.params.yield_self do |params|
      params.fetch(:command).map do |v|
        v.to_s % params.reject { |k| k == :command }
      end
    end
  end

  # String representation, is a command line.
  #
  # @return [String]
  def to_s
    Shellwords.join(self.to_a)
  end

  # Denote call will run in a privileged mode.
  #
  # @see #call
  #
  # @return [Boolean]
  def privileged?
    (config.key?('privileged') ? !!config['privileged'] : uid.zero?).yield_self { |v| true == v }
  end

  # Denote command will ``chdir`` to ``exec``.
  #
  # @return [Boolean]
  def chdir?
    params.fetch(:chdir) != Dir.pwd
  end

  def call
    "#{params.fetch(:user)}:#{params.fetch(:group)}".tap do |run_as|
      suid.change_user(run_as) if privileged?
    end

    self.chdir { exec(self.to_s) }
  end

  protected

  # @return [Array<String>]
  attr_reader :command

  # Set command.
  #
  # @param [Array, String, Object] command
  def command=(command)
    (command.is_a?(Array) ? command : Shellwords.split(command.to_s)).yield_self do |parts|
      @command = parts.to_a.map(&:to_s).freeze
    end
  end

  # Returns the user ID of this process.
  #
  # @return [Integer]
  #
  # @see https://ruby-doc.org/core-2.5.0/Process/UID.html#method-c-rid
  def uid
    Process.uid
  end

  # @return [Module<Sv::Utils::SUID>]
  def suid
    Sv::Utils::SUID
  end

  # Changes the current working directory of the process.
  #
  # @return [Object]
  #
  # @see #params
  # @see #chdir?
  # @see https://ruby-doc.org/core-2.7.0/Dir.html#method-c-chdir
  def chdir(&block)
    # noinspection RubyNilAnalysis
    {
      false => -> { Dir.chdir(params.fetch(:chdir)) { block.call } },
      true => -> { block.call }
    }.fetch(self.chdir?).call
  end
end
