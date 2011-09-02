source "http://rubygems.org"

gemspec

## Uncomment the following lines to develop against edge refinery
gem 'refinerycms', :git => 'git://github.com/resolve/refinerycms.git'
gem 'awesome_nested_set', :git => 'git://github.com/collectiveidea/awesome_nested_set.git'

group :development, :test do
  require 'rbconfig'
  gem 'sqlite3'
  gem 'mysql2'
  gem 'pg'

  platforms :mswin, :mingw do
    gem 'win32console'
    gem 'rb-fchange', '~> 0.0.5'
    gem 'rb-notifu', '~> 0.0.4'
  end

  platforms :ruby do
    gem 'spork', '0.9.0.rc9'
    gem 'guard-spork'

    unless ENV['TRAVIS']
      if Config::CONFIG['target_os'] =~ /darwin/i
        gem 'rb-fsevent', '>= 0.3.9'
        gem 'growl',      '~> 1.0.3'
      end
      if Config::CONFIG['target_os'] =~ /linux/i
        gem 'rb-inotify', '>= 0.5.1'
        gem 'libnotify',  '~> 0.1.3'
      end
    end
  end

  platforms :jruby do
    unless ENV['TRAVIS']
      if Config::CONFIG['target_os'] =~ /darwin/i
        gem 'growl',      '~> 1.0.3'
      end
      if Config::CONFIG['target_os'] =~ /linux/i
        gem 'rb-inotify', '>= 0.5.1'
        gem 'libnotify',  '~> 0.1.3'
      end
    end
  end
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', '~> 3.1.0'
  gem 'coffee-rails', '~> 3.1.0'
  gem 'uglifier'
end

gem 'jquery-rails'
