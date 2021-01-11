# frozen_string_literal: true

# ```sh
# bundle config set clean 'true'
# bundle config set path 'vendor/bundle'
# bundle install
# ```
source 'https://rubygems.org'
git_source(:github) { |name| "https://github.com/#{name}.git" }

group :default do
  gem 'dry-inflector',  '~> 0.1'
  gem 'kamaze-version', '~> 1.0'
  gem 'stibium-bundled', '~> 0.0.1'
  gem 'sys-proc', '~> 1.1', '>= 1.1.2'
end

group :development do
  { github: 'SwagDevOps/kamaze-project', branch: 'develop' }.tap do |options|
    gem(*['kamaze-project'].concat([options]))
  end

  gem 'listen', '~> 3.1'
  gem 'rake', '~> 13.0'
  gem 'rubocop', '~> 0.66'
  gem 'rugged', '~> 1.0'
  # repl ------------------------------------------------------------
  gem 'interesting_methods', '~> 0.1'
  gem 'pry', '~> 0.12'
end

group :doc do
  gem 'github-markup', '~> 3.0'
  gem 'redcarpet', '~> 3.4'
  gem 'yard', '~> 0.9'
end

group :test do
  gem 'concurrent-ruby', '~> 1.1'
  gem 'rspec', '~> 3.8'
  gem 'sham', '~> 2.0'
end
