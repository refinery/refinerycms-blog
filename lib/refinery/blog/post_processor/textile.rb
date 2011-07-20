require 'RedCloth'

module Refinery
  module Blog
    module PostProcessor
      # Post Processor for textile
      # returns HTML for given textile
      class Textile
        # process textile into html
        def self.process(markup)
          RedCloth.new(markup).to_html
        end
      end
    end
  end
end