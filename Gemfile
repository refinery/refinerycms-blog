source "http://rubygems.org"

gemspec

gem 'refinerycms', '~> 2.0.3'
gem 'refinerycms-i18n', :git => 'git://github.com/parndt/refinerycms-i18n.git', :branch => '2-0-stable'

group :development, :test do
  require 'rbconfig'
  gem 'refinerycms-testing', '~> 2.0.0'
  gem 'guard-rspec', '~> 0.6.0'

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
    gem 'spork', '0.9.0.rc9'
    gem 'guard-spork'

    unless ENV['TRAVIS']
      if RbConfig::CONFIG['target_os'] =~ /darwin/i
        gem 'rb-fsevent', '>= 0.3.9'
        gem 'growl',      '~> 1.0.3'
      end
      if RbConfig::CONFIG['target_os'] =~ /linux/i
        gem 'rb-inotify', '>= 0.5.1'
        gem 'libnotify',  '~> 0.1.3'
        gem 'therubyracer', '~> 0.9.9'
      end
    end
  end

  platforms :jruby do
    unless ENV['TRAVIS']
      if RbConfig::CONFIG['target_os'] =~ /darwin/i
        gem 'growl',      '~> 1.0.3'
      end
      if RbConfig::CONFIG['target_os'] =~ /linux/i
        gem 'rb-inotify', '>= 0.5.1'
        gem 'libnotify',  '~> 0.1.3'
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
