class RefineryBlogGenerator < Rails::Generator::NamedBase

  def initialize(*runtime_args)
    # set argument for the user.
    runtime_args[0] = %w(refinerycms_blog)
    super(*runtime_args)
  end

  def banner
    "Usage: script/generate refinery_blog"
  end

  def manifest
    tables = %w(posts comments categories).map{|t| "blog_#{t}"}
    record do |m|
      m.template('seed.rb', 'db/seeds/refinerycms_blog.rb')

      m.migration_template('migration.rb', 'db/migrate',
        :migration_file_name => "create_blog_structure",
        :assigns => {
          :migration_name => "CreateBlogStructure",
          :tables => [{
            :table_name => tables.first,
            :attributes => [
              Rails::Generator::GeneratedAttribute.new("title", "string"),
              Rails::Generator::GeneratedAttribute.new("body", "text"),
              Rails::Generator::GeneratedAttribute.new("draft", "boolean")
            ]
          },{
            :table_name => tables.second,
            :attributes => [
              Rails::Generator::GeneratedAttribute.new("name", "string"),
              Rails::Generator::GeneratedAttribute.new("email", "string"),
              Rails::Generator::GeneratedAttribute.new("body", "text")
            ]
          },{
            :table_name => tables.third,
            :attributes => [
              Rails::Generator::GeneratedAttribute.new("title", "string")
            ]
          }]
        })
    end
  end

end if defined?(Rails::Generator::NamedBase)