# frozen_string_literal: true

require 'rails_helper'

describe HistoricalWeather do
  subject { described_class.call }

  let(:url) { ENV['HISTORICAL_WEATHER_URL'] }
  let(:response) { Request.call(url) }

  before do
    VCR.use_cassette('services/historical_weather') do
      response
      allow(Request).to receive(:call) { response }
    end
  end

  describe '#call' do
    it 'call Request' do
      VCR.use_cassette('services/historical_weather') do
        subject
        expect(Request).to have_received(:call).once
      end
    end
  end

  describe '#serialize' do
    it 'return response' do
      VCR.use_cassette('services/historical_weather') do
        HistoricalWeather.send(:serialize, response)
        expect(subject).to include { be_a_kind_of(Hash).and(include('time', 'temperature')) }
      end
    end
  end
end
