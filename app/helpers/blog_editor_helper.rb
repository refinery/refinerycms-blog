module BlogEditorHelper
  def blog_post_editor
    editor = RefinerySetting.get(:blog_post_editor, {:scoping => "blog"})
    if (not markup_processor_for?(editor))
      editor = "wymeditor"
      RefinerySetting.create(:name => "blog_post_editor", :value => editor, :scoping => "blog")
    end
    return editor 
  end

  # returns true if it finds a processor class of the same name as the editor
  def markup_processor_for?(editor)
    "Refinery::Blog::PostProcessor::#{editor.camelize}".constantize.kind_of?(Class)
  rescue
    false
  end
end