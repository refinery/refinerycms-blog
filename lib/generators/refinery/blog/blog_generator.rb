module Refinery
  class BlogGenerator < Rails::Generators::Base

    def rake_db
      rake("refinery_blog:install:migrations")
    end

    def append_load_seed_data
      append_file 'db/seeds.rb', :verbose => true do
        <<-EOH

# Added by RefineryCMS Blog engine
Refinery::Blog::Engine.load_seed
        EOH
      end
    end

  end
end
