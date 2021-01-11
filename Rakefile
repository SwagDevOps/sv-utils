# frozen_string_literal: true

require_relative 'lib/sv-utils'
require 'sv/utils'
require 'sys/proc'
require 'kamaze/project'

Sys::Proc.progname = nil

Kamaze.project do |project|
  project.subject = Sv::Utils
  project.name    = 'sv-utils'
  # noinspection RubyLiteralArrayInspection
  project.tasks   = [
    'cs:correct', 'cs:control', 'cs:pre-commit',
    'doc', 'doc:watch',
    'gem', 'gem:install', 'gem:compile',
    'misc:gitignore',
    'shell', 'sources:license', 'test', 'version:edit',
  ]
end.load!

task default: [:gem]

if project.path('spec').directory?
  task :spec do |_task, args|
    Rake::Task[:test].invoke(*args.to_a)
  end
end
