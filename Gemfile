source "http://rubygems.org"

gemspec

## Uncomment the following lines to develop against edge refinery
gem 'refinerycms', :git => 'git://github.com/resolve/refinerycms.git'

# Use edge Devise for now: https://github.com/resolve/refinerycms/commit/10ab4db773d9f94b374b0a4bfb2050cb70ff4353
gem 'devise', :git => 'git://github.com/plataformatec/devise.git'

group :development, :test do  
  require 'rbconfig'
  
  platforms :mswin, :mingw do
    gem 'win32console'
    gem 'rb-fchange', '~> 0.0.5'
    gem 'rb-notifu', '~> 0.0.4'
  end

  platforms :ruby do
    gem 'spork', '0.9.0.rc9'
    gem 'guard-spork'
    
    if Config::CONFIG['target_os'] =~ /darwin/i
      gem 'rb-fsevent', '>= 0.3.9'
      gem 'growl',      '~> 1.0.3'
    end
    if Config::CONFIG['target_os'] =~ /linux/i
      gem 'rb-inotify', '>= 0.5.1'
      gem 'libnotify',  '~> 0.1.3'
    end
  end

  platforms :jruby do
    if Config::CONFIG['target_os'] =~ /darwin/i
      gem 'growl',      '~> 1.0.3'
    end
    if Config::CONFIG['target_os'] =~ /linux/i
      gem 'rb-inotify', '>= 0.5.1'
      gem 'libnotify',  '~> 0.1.3'
    end
  end
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
end

gem 'jquery-rails'
