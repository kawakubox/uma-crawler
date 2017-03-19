# frozen_string_literal: true
class ScrapePastRaceResultPageJob < ApplicationJob
  queue_as :default

  def perform(race)
    Scraper::PastRaceResultPage.new(race: race).scrape
    Scraper::PastRaceTime.new(race: race).scrape
  end
end
