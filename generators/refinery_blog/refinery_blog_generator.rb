class RefineryBlogGenerator < Rails::Generator::NamedBase

  def initialize(*runtime_args)
    # set argument for the user.
    runtime_args[0] = %w(refinerycms_blog)
    super(*runtime_args)
  end

  def banner
    'Usage: script/generate refinery_blog'
  end

  def manifest
    record do |m|
      m.template('seed.rb', 'db/seeds/refinerycms_blog.rb')

      m.migration_template('migration.rb', 'db/migrate',
        :migration_file_name => 'create_blog_structure',
        :assigns => {
          :migration_name => 'CreateBlogStructure',
          :tables => [{
            :table_name => 'blog_posts',
            :attributes => [
              Rails::Generator::GeneratedAttribute.new('title', 'string'),
              Rails::Generator::GeneratedAttribute.new('body', 'text'),
              Rails::Generator::GeneratedAttribute.new('draft', 'boolean')
            ], :id => true
          },{
            :table_name => 'blog_comments',
            :attributes => [
              Rails::Generator::GeneratedAttribute.new('name', 'string'),
              Rails::Generator::GeneratedAttribute.new('email', 'string'),
              Rails::Generator::GeneratedAttribute.new('body', 'text'),
              Rails::Generator::GeneratedAttribute.new('state', 'string'),
              Rails::Generator::GeneratedAttribute.new('blog_post_id', 'integer')
            ], :id => true
          },{
            :table_name => 'blog_categories',
            :attributes => [
              Rails::Generator::GeneratedAttribute.new('title', 'string')
            ], :id => true
          },{
            :table_name => 'blog_categories_blog_posts',
            :attributes => [
              Rails::Generator::GeneratedAttribute.new('blog_category_id', 'integer'),
              Rails::Generator::GeneratedAttribute.new('blog_post_id', 'integer')
            ], :id => false
          }]
        })
    end
  end

end if defined?(Rails::Generator::NamedBase)