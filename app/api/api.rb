# frozen_string_literal: true

require 'grape-swagger'

# Weather API
class API < Grape::API
  format :json

  # /health
  namespace :health do
    desc 'Server healthcheck'
    get do
      { message: 'Server is working' }
    end
  end

  # /weather
  namespace :weather do
    desc 'Get current temperature'
    get 'current', root: :weather do
      Rails.cache.fetch('current_weather', expires_in: 15.minutes) { CurrentWeather.call }
    end

    desc 'Get data about temperature in last 24h'
    get 'historical', root: :weather do
      Rails.cache.fetch('historical_weather', expires_in: 30.minutes) { HistoricalWeather.call }
    end

    desc 'Get max temperature in last 24h'
    get 'historical/max', root: :weather do
      historical = Rails.cache.fetch('historical_weather', expires_in: 30.minutes) { HistoricalWeather.call }
      historical.map { |h| h[:temperature] }.max
    end

    desc 'Get min temperature in last 24h'
    get 'historical/min', root: :weather do
      historical = Rails.cache.fetch('historical_weather', expires_in: 30.minutes) { HistoricalWeather.call }
      historical.map { |h| h[:temperature] }.min
    end

    desc 'Get avg temperature in last 24h'
    get 'historical/avg', root: :weather do
      historical = Rails.cache.fetch('historical_weather', expires_in: 30.minutes) { HistoricalWeather.call }
      historical.sum { |h| h[:temperature] } / historical.size
    end

    desc 'Get data about the closest temperature to the set timestamp in last 24h'
    params do
      requires :timestamp, type: String
    end

    post 'historical/by_time', root: :weather do
      historical = Rails.cache.fetch('historical_weather', expires_in: 30.minutes) { HistoricalWeather.call }

      times = historical.map { |h| h[:time].to_time.to_i }

      timestamp = params[:timestamp].to_i

      return error!(:not_found, 404) if timestamp < times.last || timestamp > times.first

      time = times.min_by { |x| (timestamp - x).abs }

      historical.select { |h| h[:time].to_time.to_i == time }.first
    end
  end

  # Swagger docs
  add_swagger_documentation \
    info: {
      title: 'Weather API'
    }
end
