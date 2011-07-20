module Refinery
  module Blog
    module PostProcessor
      # Post Processor for HTML
      # returns HTML for given HTML
      class Wymeditor
        # returns the html that was passed in (no processing needed)
        def self.process(markup)
          markup
        end
      end
    end
  end
end