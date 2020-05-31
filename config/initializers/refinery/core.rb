# encoding: utf-8
Refinery::Core.configure do |config|
  # When true will rescue all not found errors and display a friendly error page
  config.rescue_not_found = Rails.env.production?

  # When true this will force SSL redirection in all Refinery backend controllers.
  # config.force_ssl = false

  # Dragonfly and S3 configurations have moved to initializers/refinery/dragonfly.rb

  # Whenever Refinery caches anything and can set a cache key, it will add
  # a prefix to the cache key containing the string you set here.
  # config.base_cache_key = :refinery

  # Site name
  # config.site_name = "Company Name"

  # This activates Google Analytics tracking within your website. If this
  # config is left blank or set to UA-xxxxxx-x then no remote calls to
  # Google Analytics are made.
  # config.google_analytics_page_code = "UA-xxxxxx-x"

  # This activates Matomo open web analytics tracking within your website. If the server config is
  # left blank or set to analytics.example.org then the javascript tracking code will not be loaded.
  # config.matomo_analytics_server = "analytics.example.org"
  # config.matomo_analytics_site_id = "123"

  # Enable/disable authenticity token on frontend
  # config.authenticity_token_on_frontend = false

  # Register extra javascript for backend
  # config.register_javascript "prototype-rails"

  # Register extra stylesheet for backend (optional options)
  # config.register_stylesheet "custom", :media => 'screen'

  # Specify a different backend path than the default of "refinery".
  # Make sure you clear the `tmp/cache` directory after changing this setting.
  # config.backend_route = "refinery"

  # Specify a different Refinery::Core::Engine mount path than the default of "/".
  # Make sure you clear the `tmp/cache` directory after changing this setting.
  # config.mounted_path = "/"

  # Specify the order Refinery plugins appear in the admin view.
  # Plugins in the list are placed, as ordered, before any plugins not in the list.
  # config.plugin_priority = %w(refinery_pages refinery_images)
end
