source "http://rubygems.org"

## Uncomment the following lines to develop against edge refinery
gem 'refinerycms', :git => 'git://github.com/resolve/refinerycms.git'
gem 'seo_meta', :git => 'git://github.com/parndt/seo_meta.git'

gem 'jquery-rails'

group :development, :test do
  gem 'spork', '0.9.0.rc9', :platforms => :ruby
  gem 'guard-spork', :platforms => :ruby
end

group :assets do
  gem 'sass-rails', "~> 3.1.0.rc.5"
  gem 'coffee-rails', "~> 3.1.0.rc.5"
  gem 'uglifier'
end

gem 'arel', '2.1.4' # 2.1.5 is broken. see https://github.com/rails/arel/issues/72

gemspec
