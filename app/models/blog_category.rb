class BlogCategory < ActiveRecord::Base

  has_and_belongs_to_many :posts, :class_name => 'BlogPost'

  acts_as_indexed :fields => [:title]

  validates :title, :presence => true, :uniqueness => true

  has_friendly_id :title, :use_slug => true

  def post_count
    posts.select(&:live?).count
  end

end
