source "http://rubygems.org"

gemspec

git 'https://github.com/refinery/refinerycms.git', :branch => 'master' do
  gem 'refinerycms'
  gem 'refinerycms-testing', :group => [:development, :test]
end

gem 'refinerycms-i18n', :github => 'refinery/refinerycms-i18n', :branch => 'master'
gem 'refinerycms-settings', :github => 'refinery/refinerycms-settings', :branch => 'master'

group :development, :test do
  require 'rbconfig'

  gem 'guard-rspec', '~> 1.1.0'

  platforms :jruby do
    gem 'activerecord-jdbcsqlite3-adapter'
    gem 'activerecord-jdbcmysql-adapter'
    gem 'activerecord-jdbcpostgresql-adapter'
    gem 'jruby-openssl'
  end

  unless defined?(JRUBY_VERSION)
    gem 'sqlite3'
    gem 'mysql2'
    gem 'pg'
  end

  platforms :mswin, :mingw do
    gem 'win32console'
    gem 'rb-fchange', '~> 0.0.5'
    gem 'rb-notifu', '~> 0.0.4'
  end

  platforms :ruby do
    unless ENV['TRAVIS']
      if RbConfig::CONFIG['target_os'] =~ /darwin/i
        gem 'rb-fsevent', '~> 0.9.1'
        gem 'ruby_gntp',  '~> 0.3.4'
      end
      if RbConfig::CONFIG['target_os'] =~ /linux/i
        gem 'rb-inotify', '~> 0.8.8'
        gem 'libnotify',  '~> 0.7.4'
        gem 'therubyracer', '~> 0.10.1'
      end
    end
  end

  platforms :jruby do
    unless ENV['TRAVIS']
      if RbConfig::CONFIG['target_os'] =~ /darwin/i
        gem 'ruby_gntp',  '~> 0.3.4'
      end
      if RbConfig::CONFIG['target_os'] =~ /linux/i
        gem 'rb-inotify', '~> 0.8.8'
        gem 'libnotify',  '~> 0.7.4'
      end
    end
  end
end

# Refinery/rails should pull in the proper versions of these
group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
end

gem 'jquery-rails'
