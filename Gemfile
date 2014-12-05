source "https://rubygems.org"

gemspec

gem 'refinerycms', github: 'refinery/refinerycms'
gem 'refinerycms-i18n', github: 'refinery/refinerycms-i18n'
gem 'refinerycms-acts-as-indexed', github: 'refinery/refinerycms-acts-as-indexed'
gem 'filters_spam', github: 'resolve/filters_spam'

gem 'mime-types', '1.25.1'

group :test do
  gem 'refinerycms-testing', github: 'refinery/refinerycms'
  gem 'pry'
  gem 'launchy'
end

# Database Configuration
unless ENV['TRAVIS']
  gem 'activerecord-jdbcsqlite3-adapter', :platform => :jruby
  gem 'sqlite3', :platform => :ruby
end

if !ENV['TRAVIS'] || ENV['DB'] == 'mysql'
  gem 'activerecord-jdbcmysql-adapter', :platform => :jruby
  gem 'jdbc-mysql', '= 5.1.13', :platform => :jruby
  gem 'mysql2', :platform => :ruby
end

if !ENV['TRAVIS'] || ENV['DB'] == 'postgresql'
  gem 'activerecord-jdbcpostgresql-adapter', :platform => :jruby
  gem 'pg', :platform => :ruby
end

# Refinery/rails should pull in the proper versions of these
group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
end

# Load local gems according to Refinery developer preference.
if File.exist? local_gemfile = File.expand_path('../.gemfile', __FILE__)
  eval File.read(local_gemfile)
end
