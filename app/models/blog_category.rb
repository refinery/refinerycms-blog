class BlogCategory < ActiveRecord::Base

  has_many :categorizations
  has_many :posts, :through => :categorizations, :source => :blog_post

  acts_as_indexed :fields => [:title]

  validates :title, :presence => true, :uniqueness => true

  has_friendly_id :title, :use_slug => true

  def post_count
    posts.select(&:live?).count
  end

end
