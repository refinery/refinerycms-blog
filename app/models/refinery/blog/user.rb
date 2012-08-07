module Refinery
  module Blog
    class User < ActiveRecord::Base
      extend FriendlyId
      friendly_id :username, :use => [:slugged]

    end
  end
end
