require 'redcarpet'

module Refinery
  module Blog
    module PostProcessor
      # Post Processor for textile
      # returns HTML for given textile
      class Markdown
        # process textile into html
        def self.process(markup)
          Redcarpet.new(markup).to_html
        end
      end
    end
  end
end