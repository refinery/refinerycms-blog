Refinery::User.find(:all).each do |user|
  if user.plugins.where(:name => 'refinerycms_blog').blank?
    user.plugins.create(:name => "refinerycms_blog",
                        :position => (user.plugins.maximum(:position) || -1) +1)
  end
end if defined?(Refinery::User)

if defined?(Refinery::Page)
  page = Refinery::Page.create(
    :title => "Blog",
    :link_url => "/blog",
    :deletable => false,
    :position => ((Refinery::Page.maximum(:position, :conditions => {:parent_id => nil}) || -1)+1),
    :menu_match => "^/blogs?(\/|\/.+?|)$"
  )

  Refinery::Pages.config.default_parts.each do |default_page_part|
    page.parts.create(:title => default_page_part, :body => nil)
  end
end
