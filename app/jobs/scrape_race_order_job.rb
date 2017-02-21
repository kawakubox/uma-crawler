# frozen_string_literal: true

class ScrapeRaceOrderJob < ApplicationJob
  queue_as :default

  def perform(race)
    Scraper::RaceOrder.new(race: race).scrape
  end
end
