# frozen_string_literal: true

require 'uri'
require 'net/http'

# service for current weather getting
class Healthchecker
  def self.call
    uri = URI(ENV['HEALTHCHECK'])

    https = Net::HTTP.new(uri.host, uri.port)

    request = Net::HTTP::Get.new(uri)

    https.request(request).code
  end
end
