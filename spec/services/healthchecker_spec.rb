# frozen_string_literal: true

require 'rails_helper'

describe Healthchecker do
  subject { described_class.call }

  it 'make a call to health endpoint' do
    VCR.use_cassette('services/healthcheck') do
      subject
      expect(subject).to eq('200')
    end
  end
end
