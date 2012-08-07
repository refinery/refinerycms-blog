module Refinery
  class User < ActiveRecord::Base
    def to_param
      "#{id}-#{username}"
    end
  end
end
