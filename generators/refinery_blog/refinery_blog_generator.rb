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
      matches = Dir[
        File.expand_path('../../../public/images/**/*', __FILE__),
        File.expand_path('../../../public/stylesheets/**/*', __FILE__),
        File.expand_path('../../../public/javascripts/**/*', __FILE__),
      ]
      matches.reject{|d| !File.directory?(d)}.each do |dir|
        m.directory((%w(public) | dir.split('public/').last.split('/')).join('/'))
      end
      matches.reject{|f| File.directory?(f)}.each do |image|
        path = (%w(public) | image.split('public/').last.split('/'))[0...-1].join('/')
        m.template "../../../#{path}/#{image.split('/').last}", "#{path}/#{image.split('/').last}"
      end

      m.template('db/seeds/seed.rb', 'db/seeds/refinerycms_blog.rb')

      m.migration_template('db/migrate/migration.rb', 'db/migrate',
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
              Rails::Generator::GeneratedAttribute.new('blog_post_id', 'integer'),
              Rails::Generator::GeneratedAttribute.new('spam', 'boolean'),
              Rails::Generator::GeneratedAttribute.new('name', 'string'),
              Rails::Generator::GeneratedAttribute.new('email', 'string'),
              Rails::Generator::GeneratedAttribute.new('body', 'text'),
              Rails::Generator::GeneratedAttribute.new('state', 'string'),
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