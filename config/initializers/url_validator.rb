require 'net/http'

class UrlValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    url = value
    
    # Regex code by 'Arsenic' from http://snippets.dzone.com/posts/show/3654
    if url =~ /^
( (https?):\/\/ )?
( [a-z\d]+([\-\.][a-z\d]+)*\.[a-z]{2,6} )
(
(:
( \d{1,5} )
)?
( \/.* )?
)?
$/ix
      url = "http#{'s' if $7 == '81'}://#{url}" unless $1
    else
      record.errors[attribute] << 'Not a valid URL'
    end

    if options[:verify]
      begin
        url_response = RedirectFollower.new(url).resolve
        url = url_response.url if options[:verify] == [:resolve_redirects]
      rescue RedirectFollower::TooManyRedirects
        record.errors[attribute] << 'URL is redirecting too many times'
      rescue
        record.errors[attribute] << 'could not be resolved'
      end
    end

    if options[:update]
      value.replace url
    end
  end
end

# Code below written by John Nunemaker
# See blog post at http://railstips.org/blog/archives/2009/03/04/following-redirects-with-nethttp/
class RedirectFollower
  class TooManyRedirects < StandardError; end

  attr_accessor :url, :body, :redirect_limit, :response

  def initialize(url, limit=5)
    @url, @redirect_limit = url, limit
    logger.level = Logger::INFO
  end

  def logger
    @logger ||= Logger.new(STDOUT)
  end

  def resolve
    raise TooManyRedirects if redirect_limit < 0

    self.response = Net::HTTP.get_response(URI.parse(url))

    logger.info "redirect limit: #{redirect_limit}"
    logger.info "response code: #{response.code}"
    logger.debug "response body: #{response.body}"

    if response.kind_of?(Net::HTTPRedirection)
      self.url = redirect_url
      self.redirect_limit -= 1

      logger.info "redirect found, headed to #{url}"
      resolve
    end

    self.body = response.body
    self
  end

  def redirect_url
    if response['location'].nil?
      response.body.match(/<a href=\"([^>]+)\">/i)[1]
    else
      response['location']
    end
  end
end