# frozen_string_literal: true

require 'pathname'

ENV['PATH'] = '%<bin_path>s:%<env_path>s' % {
  bin_path: Pathname.new(__dir__).join('..', 'bin').realpath,
  env_path: ENV['PATH'],
}
