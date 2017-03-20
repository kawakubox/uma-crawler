# frozen_string_literal: true
class ScrapePastRaceResultPageJob < ApplicationJob
  queue_as :default

  def perform(race)
    Scraper::PastRaceResultPage.new(race: race).scrape
    Scraper::PastRaceTimePage.new(race: race).scrape
  end
end
