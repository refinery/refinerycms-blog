(Refinery.i18n_enabled? ? Refinery::I18n.frontend_locales : [:en]).each do |lang|
  I18n.locale = lang
  
  Refinery::User.all.each do |user|
    if user.plugins.where(:name => 'refinerycms_blog').blank?
      user.plugins.create(:name => "refinerycms_blog",
                          :position => (user.plugins.maximum(:position) || -1) +1)
    end
  end if defined?(Refinery::User)
  
  if defined?(Refinery::Page) and !Refinery::Page.exists?(:link_url => '/blog')
    page = Refinery::Page.create(
      :title => "Blog",
      :link_url => "/blog",
      :deletable => false,
      :menu_match => "^/blogs?(\/|\/.+?|)$"
    )
  
    Refinery::Pages.default_parts.each do |default_page_part|
      page.parts.create(:title => default_page_part, :body => nil)
    end
  end
end
