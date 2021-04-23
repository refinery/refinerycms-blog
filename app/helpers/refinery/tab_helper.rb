module Refinery
  module TabHelper
    class << self

      def to_id(*segments)
        "#" << TabHelper.to_slug(*segments)
      end

      def to_slug(*segments)
        [segments].join('_').gsub(/\W/, '').downcase
      end
    end
  end
end
