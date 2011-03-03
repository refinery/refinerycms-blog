require 'refinery/generators'

class RefinerycmsBlogGenerator < ::Refinery::Generators::EngineInstaller

  source_root File.expand_path('../../../', __FILE__)
  argument :name, :type => :string, :default => 'blog_structure', :banner => ''
  engine_name "refinerycms-blog"

end