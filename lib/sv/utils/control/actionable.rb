# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../control'
require 'dry/inflector'

autoload :Pathname, 'pathname'
autoload :FileUtils, 'fileutils'

# Provides actions.
module Sv::Utils::Control::Actionable
  singleton_class.include(self)

  # Get actions.
  #
  # @see #enable
  # @see #disable
  # @return [Hash{Symbol => Method}]
  def actions
    {
      enable: self.method(:enable),
      disable: self.method(:disable),
    }
  end

  # Method used to enable service.
  #
  # @param [Hash{Symbol => Object}] params
  # @return [Symbol]
  def method_for(params)
    {
      cp: :cp_r,
      ln: :ln_sf,
    }[params[:method].to_s.to_sym] || :ln_sf
  end

  protected

  # @param [String|Symbol|Object] service
  # @param [Hash{Symbol => Object}] params
  # @raise Errno::EINVAL
  # @return [Array<String>]
  def enable(service, params = {}) # rubocop:disable Metrics/AbcSize
    service_dir = params[:paths].fetch(0).join(service.to_s)

    auto_start(service_dir, params[:auto_start], params[:futils]).tap do |res|
      params[:paths].fetch(1).join(service.to_s).tap do |target_dir|
        futils(params[:futils]).tap do |futils|
          futils.rm_rf(target_dir)
          futils.public_send(method_for(params), service_dir, target_dir)
        end

        return res.push(target_dir)
      end
    end
  end

  # @param [Pathname] service_dir
  # @param [Boolean] auto_start
  # @param [String|Symbol|nil] mode
  # @return [Array<String>]
  def auto_start(service_dir, auto_start, mode)
    method = auto_start ? :rm_rf : :touch

    [service_dir.join('down'),
     service_dir.join('log', 'down')].tap do |paths|
      paths.each do |fp|
        next unless fp.dirname.directory?

        futils(mode).public_send(method, fp)
      end
    end
  end

  # @param [String|Symbol|Object] service
  # @param [Hash{Symbol => Object}] params
  # @return [Array<String>]
  def disable(service, params = {})
    utils = futils(params[:futils])
    target_dir = params[:paths].fetch(1).join(service.to_s)

    utils.rm_f(target_dir)
  end

  # @return [Fileutils|Fileutils::Verbose|Fileutils::DryRun|Fileutils::NoWrite]
  def futils(mode = :verbose)
    mode = mode ? mode.to_s.to_sym : mode
    return FileUtils unless [:verbose, :dry_run, :no_write].include?(mode)

    FileUtils.const_get(Dry::Inflector.new.classify(mode))
  end
end
