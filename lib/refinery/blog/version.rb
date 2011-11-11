module Refinery
  module Blog
    class Version
      @major = 1
      @minor = 6
      @tiny  = 3

      class << self
        attr_reader :major, :minor, :tiny

        def to_s
          [@major, @minor, @tiny].compact.join('.')
        end
      end
    end
  end
end