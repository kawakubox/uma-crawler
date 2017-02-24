# frozen_string_literal: true

class ScrapeRaceResultsJob < ApplicationJob
  queue_as :default

  def perform(race)
    Scraper::RaceResults.new(race: race).scrape
  end
end
