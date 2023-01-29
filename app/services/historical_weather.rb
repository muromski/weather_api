# frozen_string_literal: true

# service for current weather getting
class HistoricalWeather
  # Location for searching - Minsk
  def self.call
    response = Request.call(ENV['HISTORICAL_WEATHER_URL'])

    serialize(response)
  end

  def self.serialize(response)
    data_array = JSON.parse(response.read_body)

    array_of_hashes = []

    data_array.each do |record|
      array_of_hashes << {
        'time': record['LocalObservationDateTime'],
        'temperature': record['Temperature']['Metric']['Value']
      }
    end

    array_of_hashes
  end

  private_class_method :serialize
end
