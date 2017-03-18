# frozen_string_literal: true

class ScrapeRaceJob < ApplicationJob
  queue_as :default

  # @param [Race] :race
  def perform(race)
    scraper = Scraper::RaceMeta.new(html: open(race.result_url))
    race.no = scraper.race_no
    race.times = scraper.ordinal
    race.title = scraper.title
    race.grade = scraper.grade
    race.course_type = scraper.course_type
    race.direction = scraper.direction
    race.distance = scraper.distance
    race.weather = scraper.weather
    race.course_condition = scraper.course_condition
    race.save
  end
end
