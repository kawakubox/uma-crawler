# frozen_string_literal: true
class ScrapePastRaceResultJob < ApplicationJob
  queue_as :default

  def perform(race)
    Scraper::PastRaceResult.new(race: race).scrape
  end
end
