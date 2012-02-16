module Refinery
  class BlogGenerator < Rails::Generators::Base

    source_root File.expand_path("../templates", __FILE__)

    def generate_blog_initializer
      template "config/initializers/refinery/blog.rb.erb", File.join(destination_root, "config", "initializers", "refinery", "blog.rb")
    end

    def rake_db
      rake("refinery_blog:install:migrations")
    end

    def append_load_seed_data
      create_file 'db/seeds.rb' unless File.exists?(File.join(destination_root, 'db', 'seeds.rb'))
      append_file 'db/seeds.rb', :verbose => true do
        <<-EOH

# Added by RefineryCMS Blog engine
Refinery::Blog::Engine.load_seed
        EOH
      end
    end

  end
end
