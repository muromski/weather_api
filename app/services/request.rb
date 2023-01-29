# frozen_string_literal: true

require 'uri'
require 'net/http'

# service for current weather getting
class Request
  def self.call(url)
    uri = URI(url)

    uri.query = URI.encode_www_form(params)

    https = Net::HTTP.new(uri.host, uri.port)

    request = Net::HTTP::Get.new(uri)

    https.request(request)
  end

  def self.params
    {
      apikey: ENV['API_KEY'],
      language: 'en-us',
      details: 'false'
    }
  end

  private_class_method :params
end
