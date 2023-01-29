# frozen_string_literal: true

# service for current weather getting
class CurrentWeather
  # Location for searching - Minsk
  def self.call
    response = Request.call(ENV['CURRENT_WEATHER_URL'])

    serialize(response)
  end

  def self.serialize(response)
    JSON.parse(response.read_body).first['Temperature']['Metric']['Value'] if response
  end

  private_class_method :serialize
end
