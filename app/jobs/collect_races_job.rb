class CollectRacesJob < ApplicationJob
  queue_as :default

  def perform
    ::Event.find_each do |event|
      scraper = Scraper::Event.new(html: open(event.url), event: event)
      scraper.races
      sleep(5)
    end
  end
end
