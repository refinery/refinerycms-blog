require 'nokogiri'

namespace :wordpress do
  desc "Reset the blog relevant tables for a clean import"
  task :reset do
    Rake::Task["environment"].invoke

    %w(blog_categories blog_posts).each do |table_name|
      p "Truncating #{table_name} ..."
      ActiveRecord::Base.connection.execute "TRUNCATE TABLE #{table_name}"
    end
  end

  desc "Import data from a WordPress XML dump"
  task :import, :file_name do |task, params|
    Rake::Task["environment"].invoke

    file_name = File.absolute_path(params[:file_name])
    unless File.file?(file_name) && File.readable?(file_name)
      raise "Given file '#{file_name}' no file or not readable."
    end

    file = File.open(file_name)
    doc = Nokogiri::XML(file)
    file.close

    p "Importing blog categories ..."
    doc.xpath("//wp:category/wp:cat_name").each do |category|
      BlogCategory.exists?(:title => category.text) || BlogCategory.create!(:title => category.text)
    end

    doc.xpath("//wp:tag/wp:tag_slug").each do |tag|
      p tag.text
    end

    doc.xpath("//item").each do |post|
      title = post.xpath("title").text
      body = post.xpath("content:encoded").text
      author = post.xpath("dc:creator").text
      published_at = DateTime.parse(post.xpath("wp:post_date").text)

      tags = post.xpath("category[@domain='tag'][not(@nicename)]").collect {|tag| tag.text }
      tag_list = tags.join(', ')

      categories = post.xpath("category[not(@*)]").collect {|cat| cat.text }


      p '*' * 100
      p title
      p author
      p published_at
      p tag_list
      p categories
    end
  end
  
  desc "Import data from a WordPress XML dump into a clean database (reset first)"
  task :import_clean, :file_name do |task, params|
    Rake::Task["wordpress:reset"].invoke
    Rake::Task["wordpress:import"].invoke(params[:file_name])

  end
end
