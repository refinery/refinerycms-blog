module Refinery
  module Blog
    class Version
      @major = 1
      @minor = 5
      @tiny  = 1

      class << self
        attr_reader :major, :minor, :tiny

        def to_s
          [@major, @minor, @tiny].compact.join('.')
        end
      end
    end
  end
end