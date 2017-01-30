# frozen_string_literal: true

class ScrapeRefundsJob < ApplicationJob
  queue_as :default

  def perform(race:)
    Scraper::Refund.new(race: race).scrape
  end
end
