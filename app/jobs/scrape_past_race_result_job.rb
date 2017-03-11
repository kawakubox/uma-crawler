# frozen_string_literal: true
class ScrapeRaceEntryJob < ApplicationJob
  queue_as :default

  def perform(race)
    Scraper::RaceEntry.new(race: race).scrape
  end
end
