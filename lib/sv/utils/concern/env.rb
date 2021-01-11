# frozen_string_literal: true

# Copyright (C) 3017-2021 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../concern'

# Provides clean env.
#
# @see https://github.com/bundler/bundler/blob/7b603f39e32a466cb1a8235a963968b2103e665e/lib/bundler.rb#L284
module Sv::Utils::Concern::Env
  BUNDLER_INTENTIONALLY_NIL = 'BUNDLER_ENVIRONMENT_PRESERVER_INTENTIONALLY_NIL'

  def with_clean_env
    with_env(clean_env) { yield }
  end

  # @param [Hash] env
  def with_env(env)
    backup = ENV.to_hash
    ENV.replace(env)
    yield
  ensure
    ENV.replace(backup)
  end

  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/AbcSize

  # @return [Hash]
  def clean_env
    ENV.to_hash.clone.tap do |env|
      if env.key?('BUNDLER_ORIG_MANPATH')
        env['MANPATH'] = env['BUNDLER_ORIG_MANPATH']
      end

      env.delete_if do |k, v|
        k[0, 7] == 'BUNDLE_' or v == BUNDLER_INTENTIONALLY_NIL
      end

      if env.key?('RUBYOPT')
        env['RUBYOPT'] = env['RUBYOPT'].sub('-rbundler/setup', '')
      end

      if env.key?('RUBYLIB')
        rubylib = env['RUBYLIB'].split(File::PATH_SEPARATOR)
        rubylib.delete(File.expand_path(__dir__))
        env['RUBYLIB'] = rubylib.join(File::PATH_SEPARATOR)
      end
    end.sort.to_h
  end

  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/AbcSize
end
