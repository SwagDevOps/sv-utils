# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../utils'
autoload :Etc, 'etc'

# Provides ``change_user`` method.
module Sv::Utils::SUID
  singleton_class.include(self)

  # If `permanently` is set, will permanently change the uid/gid of the
  # process. If not, it will only set the euid/egid.
  #
  # ``ENV`` will be modified using ``passwd`` entry, to reflect changes.
  # And will be restored after block execution.
  #
  # @param [String|Symbol|Integer] user
  # @param [Boolean] permanently
  # @return [Etc::Passwd]
  #
  # @note Only ``permanently`` set to ``true`` seems to be reliable,
  #       ``false`` leads to suprises.
  def change_user(user, permanently = true)
    user_load(user).tap do |u|
      util.change_privileges(u.uid, u.gid, permanently)
      ENV.replace(altered_env(u))

      if block_given?
        yield
        ENV.replace(u.proc_env)
      end
    end
  end

  protected

  # Load user for given username or uid.
  #
  # Keep track of previous state using added ``proc_`` methods.
  #
  # @param [String|Symbol|Integer] user
  # @return [Etc::Passwd]
  def user_load(user)
    user = user.is_a?(Integer) ? Etc.getpwuid(user) : Etc.getpwnam(user.to_s)

    user.tap do |u|
      {
        proc_env: ENV.to_hash.clone,
        proc_uid: Process.uid,
        proc_gid: Etc.getpwuid(Process.uid).gid
      }.each do |k, v|
        u.singleton_class.__send__(:define_method, k) { v }
      end
    end
  end

  # Get an altered version of environment.
  #
  # Wil use given user passwd entry or process ''euid``.
  #
  # @param [Etc::Passwd|nil] passwd
  # @param [ENV|Hash] env
  # @return [ENV|Hash]
  def altered_env(passwd = nil, env = ENV.clone)
    env.tap do |env| # rubocop:disable Lint/ShadowingOuterLocalVariable
      (passwd || Etc.getpwuid(Process.uid)).tap do |user|
        {
          'HOME' => user.dir,
          'LOGNAME' => user.name,
          'USER' => user.name,
          'USERNAME' => user.name,
        }.each { |k, v| env[k] = v if env.key?(k) }
      end
    end
  end

  # @return [Puppet::Util::SUIDManager]
  def util
    require 'puppet'
    require 'puppet/util/suidmanager'

    Puppet::Util::SUIDManager
  end
end
