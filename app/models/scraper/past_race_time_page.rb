# frozen_string_literal: true
module Scraper
  class PastRaceTimePage
    attr_reader :doc

    # @param [Race] :race
    def initialize(race:)
      @doc = Nokogiri::HTML(open(race.past_race_time_url)).at_css('.denmaLs')
    end

    def scrape
      doc.search('tr')[1..-1].map { |tr| row(tr) }
    end

    def row(tr)
      horse = Horse.find_or_create_by(id: horse_id(tr)) do |instance|
        instance.name = horse_name(tr)
      end

      tr.search('td')[4..-1].map do |td|
        next if td.text.strip.blank?

        scraper = Scraper::PastRaceTime.new(td.to_html)

        h = HorseHistory.find_or_initialize_by(horse: horse, race: Race.find_or_create_by(id: scraper.race_id))
        h.passage_order = scraper.passage_order
        h.last_3f_time = scraper.last_3f_time
        h.save
      end
    end

    def horse_id(tr)
      tr.search('td')[2].at_css('a').attr('href').match(/(\d+)/)[1]
    end

    def horse_name(tr)
      tr.search('td')[2].at_css('a').text.strip
    end
  end
end
