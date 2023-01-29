# frozen_string_literal: true

require 'rails_helper'

describe API do
  let(:memory_store) { ActiveSupport::Cache.lookup_store(:memory_store) }
  let(:cache) { Rails.cache }

  context 'GET /health' do
    it 'should return a status code 200' do
      get '/health'

      expect(response.status).to eq(200)
    end
  end

  context 'when this is a weather operations' do
    before do
      allow(Rails).to receive(:cache).and_return(memory_store)
      Rails.cache.clear
    end

    context 'GET /weather/current' do
      it 'should return current weather' do
        VCR.use_cassette('current_weather') do
          get '/weather/current'

          expect(response.status).to eq(200)
          expect(JSON.parse(response.body)).to be_a_kind_of(Float)
          expect(Rails.cache.read('current_weather')).to be
        end
      end
    end

    context 'GET /weather/historical' do
      it 'should return data about weather in last 24h' do
        VCR.use_cassette('historical_weather') do
          get '/weather/historical'

          expect(response.status).to eq(200)
          expect(JSON.parse(response.body)).to include(
            be_a_kind_of(Hash).and(include('time', 'temperature'))
          ).at_least(24).times

          expect(Rails.cache.read('historical_weather')).to be
        end
      end
    end

    context 'GET /weather/historical/max' do
      let(:historical_weather) { Rails.cache.read('historical_weather') }
      let(:max_temperature) { historical_weather.map { |h| h[:temperature] }.max }

      it 'should return max temperature in last 24h' do
        VCR.use_cassette('historical_weather') do
          get '/weather/historical/max'

          expect(response.status).to eq(200)
          expect(JSON.parse(response.body)).to eq(max_temperature)
        end
      end
    end

    context 'GET /weather/historical/min' do
      let(:historical_weather) { Rails.cache.read('historical_weather') }
      let(:min_temperature) { historical_weather.map { |h| h[:temperature] }.min }

      it 'should return min temperature in last 24h' do
        VCR.use_cassette('historical_weather') do
          get '/weather/historical/min'

          expect(response.status).to eq(200)
          expect(JSON.parse(response.body)).to eq(min_temperature)
        end
      end
    end

    context 'GET /weather/historical/avg' do
      let(:historical_weather) { Rails.cache.read('historical_weather') }
      let(:average_temperature) { historical_weather.sum { |h| h[:temperature] } / historical_weather.size }

      it 'should return avg temperature in last 24h' do
        VCR.use_cassette('historical_weather') do
          get '/weather/historical/avg'

          expect(response.status).to eq(200)
          expect(JSON.parse(response.body)).to eq(average_temperature)
        end
      end
    end

    context 'POST /weather/historical/by_time' do
      context 'without timestamp' do
        it 'should return a status code 400' do
          VCR.use_cassette('historical_weather') do
            post '/weather/historical/by_time', params: {}

            expect(response.status).to eq(400)
          end
        end
      end

      context 'with timestamp out of range' do
        let(:params) { { timestamp: 0o0000000 } }

        it 'should return a status code 404' do
          VCR.use_cassette('historical_weather') do
            post '/weather/historical/by_time', params: params

            expect(response.status).to eq(404)
            expect(Rails.cache.read('historical_weather')).to be
          end
        end
      end

      context 'with valid timestamp' do
        before do
          VCR.use_cassette('historical_weather') do
            get '/weather/historical/'
          end
        end

        let(:timestamp) { Rails.cache.read('historical_weather').first[:time].to_time.to_i }
        let(:params) { { timestamp: timestamp - 10 } }
        let(:time) { DateTime.strptime(timestamp.to_s, '%s') }

        it 'should return data about the closest temperature to the set timestamp in last 24h' do
          VCR.use_cassette('historical_weather') do
            post '/weather/historical/by_time', params: params

            expect(response.status).to eq(201)
            expect(JSON.parse(response.body)).to include('time' => time)
          end
        end
      end
    end
  end
end
