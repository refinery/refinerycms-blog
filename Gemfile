source "https://rubygems.org"

gemspec

git 'https://github.com/refinery/refinerycms.git' do
  gem 'refinerycms-authentication'
  gem 'refinerycms-dashboard'
  gem 'refinerycms-pages'
  gem 'refinerycms-testing', group: :test
end
gem 'refinerycms-i18n', github: 'refinery/refinerycms-i18n'
gem 'refinerycms-settings', github: 'refinery/refinerycms-settings'
gem 'refinerycms-acts-as-indexed', github: 'refinery/refinerycms-acts-as-indexed'
gem 'protected_attributes'
gem 'mime-types', '1.25.1'

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

group :test do
  gem 'launchy'
end
group :development, :test do
  gem 'pry'
  gem 'pry-nav'
end

# Load local gems according to Refinery developer preference.
if File.exist? local_gemfile = File.expand_path('../.gemfile', __FILE__)
  eval File.read(local_gemfile)
end
