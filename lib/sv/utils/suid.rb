# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../utils'
autoload :Etc, 'etc'

# Provides ``change_user`` method.
#
# Mostly an abstraction on top of
# ``Etc``, ``Process::GID`` and ``Process::UID``.
#
# Sample of use:
#
# ```ruby
# Sv::Utils::SUID.change_user(:dimitri) do
#   pp [Process.uid, Process.euid]
#   # [1000, 1000]
#   pp ENV['USER']
#   # "dimitri"
#   system('whoami')
#   # dimitri
#   system('rm -rf ~/plop; touch ~/plop; ls -l ~/plop')
#   # -rw-r--r-- 1 dimitri dimitri 0 juil. 24 19:21 /home/dimitri/plop
# end
# ```
#
# Unless permanent, block use is not encouraged.
#
# @see https://ruby-doc.org/stdlib-2.5.0/libdoc/etc/rdoc/Etc.html
# @see https://ruby-doc.org/core-2.5.0/Process/GID.html
# @see https://ruby-doc.org/core-2.5.0/Process/UID.html
module Sv::Utils::SUID
  singleton_class.include(self)

  # If `permanent` is set, will permanently change the uid/gid of the
  # process. If not, it will only set the euid/egid.
  #
  # ``ENV`` will be modified using ``passwd`` entry, to reflect changes.
  # And will be restored after block execution, unless ``permanent``.
  #
  # @param [String|Symbol|Integer] user
  # @param [Boolean] permanent
  # @return [Etc::Passwd]
  #
  # @note Only ``permanent`` set to ``true`` seems to be reliable,
  #       ``false`` leads to suprises.
  def change_user(user, options = {})
    permanent = options.key?(:permanent) ? options[:permanent] : true

    load_user(user).tap do |u|
      change_privileges(u.uid, u.gid, permanent)
      altered_env(u).tap { |env| ENV.replace(env) }

      if block_given?
        yield
        change_privileges(u.proc_uid, u.proc_gid, false) unless permanent
        ENV.replace(u.proc_env) unless permanent
      end
    end
  end

  protected

  # If `permanent` is set, will permanently change the uid/gid of the
  # process. If not, it will only set the euid/egid.
  #
  # @param [Integer] uid
  # @param [Integer|nil] gid
  # @param [Boolean] permanent
  # @return [Array<Integer>]
  def change_privileges(uid, gid = nil, permanent = true)
    method = permanent ? :change_privilege : :grant_privilege
    {
      Process::GID => gid || Etc.getpwuid(uid).gid,
      Process::UID => uid,
    }.map do |k, v|
      k.public_send(method, v)
    end
  end

  # Load user for given username or uid.
  #
  # Supports UNIX format "{user}:[group]"
  # to load user with expected ``gid``.
  # Keeps track of previous state using added ``proc_`` methods.
  #
  # @param [String|Symbol|Integer] user
  # @return [Etc::Passwd]
  def load_user(user)
    fetch_user(user).tap do |u|
      {
        proc_env: ENV.to_hash.clone.freeze,
        proc_uid: Process.uid,
        proc_gid: Etc.getpwuid(Process.uid).gid
      }.each do |k, v|
        u.singleton_class.__send__(:define_method, k) { v }
      end
    end
  end

  # @param [String|Symbol|Integer] user
  # @return [Etc::Passwd]
  def fetch_user(user_ident)
    return Etc.getpwuid(user_ident) if user_ident.is_a?(Integer)

    user_ident.to_s.split(':').tap do |parts|
      Etc.getpwnam(parts.fetch(0)).tap do |user|
        user.gid = Etc.getgrnam(parts.fetch(1)).gid if parts[1]

        return user
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
end
