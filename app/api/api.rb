# frozen_string_literal: true

require 'grape-swagger'

# Weather API
class API < Grape::API
  format :json

  # /health
  namespace :health do
    get do
      { message: 'Server is working' }
    end
  end

  # Swagger docs
  add_swagger_documentation \
    info: {
      title: 'Notes API'
    }
end
