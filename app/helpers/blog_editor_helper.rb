module BlogEditorHelper
  def use_textile?
    ::RefinerySetting.get("use_textile_for_blog_posting", :scoping => "blog")
  end
end