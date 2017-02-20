class CollectRacesJob < ApplicationJob
  queue_as :default

  # @param [Event] :event
  def perform(event)
    scraper = Scraper::Event.new(html: open(event.url), event: event)
    scraper.races
  end
end
