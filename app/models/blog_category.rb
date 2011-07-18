class BlogCategory < ActiveRecord::Base

  has_many :categorizations, :dependent => :destroy
  has_many :posts, :through => :categorizations, :source => :blog_post

  acts_as_indexed :fields => [:title]

  validates :title, :presence => true, :uniqueness => true

  has_friendly_id :title, :use_slug => true,
                  :default_locale => (::Refinery::I18n.default_frontend_locale rescue :en),
                  :approximate_ascii => RefinerySetting.find_or_set(:approximate_ascii, false, :scoping => 'blog'),
                  :strip_non_ascii => RefinerySetting.find_or_set(:strip_non_ascii, false, :scoping => 'blog')

  def post_count
    posts.select(&:live?).count
  end

end
