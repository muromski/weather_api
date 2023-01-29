# frozen_string_literal: true

require 'rails_helper'

describe CurrentWeather do
  subject { described_class.call }

  let(:url) { ENV['CURRENT_WEATHER_URL'] }
  let(:response) { Request.call(url) }

  before do
    VCR.use_cassette('services/current_weather') do
      response
      allow(Request).to receive(:call) { response }
    end
  end

  describe '#call' do
    it 'call Request' do
      VCR.use_cassette('services/current_weather') do
        subject
        expect(Request).to have_received(:call).once
      end
    end
  end

  describe '#serialize' do
    it 'return response' do
      VCR.use_cassette('services/current_weather') do
        CurrentWeather.send(:serialize, response)
        expect(subject).to be_a_kind_of(Float)
      end
    end
  end
end
