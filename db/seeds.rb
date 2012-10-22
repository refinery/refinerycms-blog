Refinery::User.all.each do |user|
  if user.plugins.where(:name => 'refinerycms_blog').blank?
    user.plugins.create(:name => "refinerycms_blog",
      :position => (user.plugins.maximum(:position) || -1) +1)
  end
end if defined?(Refinery::User)

if defined?(Refinery::Page) and !Refinery::Page.exists?(:link_url => '/blogs')
  page = Refinery::Page.create(
    :title => "Blogs",
    :link_url => "/blogs",
    :deletable => false,
    :menu_match => "^/blogs?(\/|\/.+?|)$"
    )

  Refinery::Pages.default_parts.each do |default_page_part|
    page.parts.create(:title => default_page_part, :body => nil)
  end

  (Refinery.i18n_enabled? ? Refinery::I18n.frontend_locales : [:en]).each do |lang|
    I18n.locale = lang
    Refinery::Page.find_by_title("Blogs").update_attributes(:slug => "blogs")
  end
end
