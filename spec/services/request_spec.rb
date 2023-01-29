# frozen_string_literal: true

require 'rails_helper'

describe Request do
  subject { described_class.call(ENV['CURRENT_WEATHER_URL']) }

  it 'make a call to other API' do
    VCR.use_cassette('services/request') do
      subject
      expect(subject.code).to eq('200')
      expect(subject.body).to include('Temperature')
    end
  end
end
