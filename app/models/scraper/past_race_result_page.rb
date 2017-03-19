# frozen_string_literal: true
module Scraper
  class PastRaceResultPage
    attr_reader :doc

    # @param [Race] :race
    def initialize(race:)
      @doc = Nokogiri::HTML(open(race.past_race_results_url)).at_css('.denmaLs')
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

        scraper = Scraper::PastRaceResult.new(td.to_html)

        h = HorseHistory.find_or_initialize_by(horse: horse, race: Race.find_or_create_by(id: scraper.race_id))
        h.order = scraper.order
        h.jockey = Jockey.find_or_create_by(id: scraper.jockey_id)
        h.jockey_weight = scraper.jockey_weight
        h.time = scraper.time
        h.weight = scraper.weight
        h.weight_diff = scraper.weight_diff
        h.gate_no = scraper.gate_no
        h.horse_no = scraper.horse_no
        h.popularity = scraper.popularity
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
