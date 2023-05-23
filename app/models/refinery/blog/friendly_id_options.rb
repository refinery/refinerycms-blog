class FriendlyIdOptions
  def self.options
    # Docs for friendly_id https://github.com/norman/friendly_id
    friendly_id_options = {
      use: [:mobility, :reserved],
      reserved_words: Refinery::Pages.friendly_id_reserved_words
    }
    if ::Refinery::Blog.scope_slug_by_parent
      friendly_id_options[:use] << :scoped
      friendly_id_options.merge!(scope: :parent)
    end

    friendly_id_options
  end
end
