require 'rubygems'
require 'bundler'
Bundler.require

require 'filters_spam'

module Refinery
  autoload :BlogGenerator, 'generators/refinery/blog/blog_generator'
  
  module Blog
    autoload :Version, 'refinery/blog/version'
    autoload :Tab, 'refinery/blog/tabs'

    class << self
      attr_accessor :root
      def root
        @root ||= Pathname.new(File.expand_path('../../', __FILE__))
      end

      def version
        ::Refinery::Blog::Version.to_s
      end
      
      def factory_paths
        @factory_paths ||= [ File.expand_path("../../spec/factories", __FILE__) ]
      end
    end
  end
end

require 'refinery/blog/engine' if defined?(Rails)
