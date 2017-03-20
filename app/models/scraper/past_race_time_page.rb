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
        h = HorseHistory.find_or_initialize_by(horse: horse, race: Race.find_or_create_by(id: race(td)))
        h.jockey = Jockey.find_or_create_by(id: jockey_id(td))
        h.jockey_weight = jockey_weight(td)
        h.passage_order = passage_order(td)
        h.last_3f_time = last_3f_time(td)
        h.save
      end
    end

    def horse_id(tr)
      tr.search('td')[2].at_css('a').attr('href').match(/(\d+)/)[1]
    end

    def horse_name(tr)
      tr.search('td')[2].at_css('a').text.strip
    end

    def jockey_id(td)
      td.search('a')[1].attr('href').match(/(\d+)/)[1]
    end

    def jockey_weight(td)
      td.search('a')[1].next_sibling.text.delete('()')
    end

    def race(td)
      td.search('a')[0].attr('href').match(/(\d+)/)[1]
    end

    def passage_order(td)
      md = td.text.match(/((\d{2}-)+\d{2})/)
      md[1] if md
    end

    def last_3f_time(td)
      td.text.match(/\(.*\) ([0-9.]{4})/)[1]
    end
  end
end
