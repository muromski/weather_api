# frozen_string_literal: true

require 'rufus-scheduler'

scheduler = Rufus::Scheduler.singleton
scheduler.every('1m') do
  health_status = Healthchecker.call
  Rails.logger.info "#{Time.now} - Server is working, I checked it out" if health_status == '200'
end
