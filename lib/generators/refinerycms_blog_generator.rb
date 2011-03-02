require 'rails/generators/migration'

class RefinerycmsBlogGenerator < Rails::Generators::NamedBase
  include Rails::Generators::Migration

  source_root File.expand_path('../refinerycms_blog/templates/', __FILE__)
  argument :name, :type => :string, :default => 'blog_structure', :banner => ''

  def generate
    # seed file
    template 'db/seeds/seed.rb', Rails.root.join('db/seeds/refinerycms_blog.rb')

    # migration file
    @refinerycms_blog_tables = [{
       :table_name => 'blog_posts',
       :attributes => [
         Rails::Generators::GeneratedAttribute.new('title', 'string'),
         Rails::Generators::GeneratedAttribute.new('body', 'text'),
         Rails::Generators::GeneratedAttribute.new('draft', 'boolean'),
         Rails::Generators::GeneratedAttribute.new('published_at', 'datetime')
       ], :id => true
     },{
       :table_name => 'blog_comments',
       :attributes => [
         Rails::Generators::GeneratedAttribute.new('blog_post_id', 'integer'),
         Rails::Generators::GeneratedAttribute.new('spam', 'boolean'),
         Rails::Generators::GeneratedAttribute.new('name', 'string'),
         Rails::Generators::GeneratedAttribute.new('email', 'string'),
         Rails::Generators::GeneratedAttribute.new('body', 'text'),
         Rails::Generators::GeneratedAttribute.new('state', 'string'),
       ], :id => true
     },{
       :table_name => 'blog_categories',
       :attributes => [
         Rails::Generators::GeneratedAttribute.new('title', 'string')
       ], :id => true
     },{
       :table_name => 'blog_categories_blog_posts',
       :attributes => [
         Rails::Generators::GeneratedAttribute.new('blog_category_id', 'integer'),
         Rails::Generators::GeneratedAttribute.new('blog_post_id', 'integer')
       ], :id => false
     }]
    unless Pathname.glob(Rails.root.join('db', 'migrate', "*_create_#{singular_name}.rb")).any?
      next_migration_number = ActiveRecord::Generators::Base.next_migration_number(File.dirname(__FILE__))
      template('db/migrate/migration_number_create_singular_name.rb',
               Rails.root.join("db/migrate/#{next_migration_number}_create_#{singular_name}.rb"))
    end
    unless Pathname.glob(Rails.root.join('db', 'migrate', "*_add_user_id_to_blog_posts.rb")).any?
      next_migration_number = ActiveRecord::Generators::Base.next_migration_number(File.dirname(__FILE__))
      template('db/migrate/migration_number_add_user_id_to_blog_posts.rb',
               Rails.root.join('db', 'migrate', "#{next_migration_number}_add_user_id_to_blog_posts.rb"))
    end

    puts "------------------------"
    puts "Now run:"
    puts "rake db:migrate"
    puts "------------------------"
  end
end

# Below is a hack until this issue:
# https://rails.lighthouseapp.com/projects/8994/tickets/3820-make-railsgeneratorsmigrationnext_migration_number-method-a-class-method-so-it-possible-to-use-it-in-custom-generators
# is fixed on the Rails project.

require 'rails/generators/named_base'
require 'rails/generators/migration'
require 'rails/generators/active_model'
require 'active_record'

module ActiveRecord
  module Generators
    class Base < Rails::Generators::NamedBase #:nodoc:
      include Rails::Generators::Migration

      # Implement the required interface for Rails::Generators::Migration.
      def self.next_migration_number(dirname) #:nodoc:
        next_migration_number = current_migration_number(dirname) + 1
        if ActiveRecord::Base.timestamped_migrations
          [Time.now.utc.strftime("%Y%m%d%H%M%S"), "%.14d" % next_migration_number].max
        else
          "%.3d" % next_migration_number
        end
      end
    end
  end
end
