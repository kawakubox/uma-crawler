# frozen_string_literal: true

class CollectEventsJob < ApplicationJob
  queue_as :default

  # @param [Fixnum] :from
  # @param [Fixnum] :to
  def perform(from, to = nil)
    to ||= from
    years = (from..to).to_a
    months = (1..12).to_a
    years.product(months).each do |y, m|
      url = "http://keiba.yahoo.co.jp/schedule/list/#{y}/?month=#{m}"
      scraper = Scraper::Schedule.new(html: open(url))
      scraper.events
      sleep(5)
    end
  end
end
