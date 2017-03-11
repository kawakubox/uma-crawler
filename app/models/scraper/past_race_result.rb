# frozen_string_literal: true
module Scraper
  class PastRaceResult
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
        h = HorseHistory.find_or_initialize_by(horse: horse, race: Race.find_or_create_by(id: race(td)))
        h.order = order(td)
        h.jockey = Jockey.find_or_create_by(id: jockey_id(td))
        h.jockey_weight = jockey_weight(td)
        h.time = time(td)
        h.weight = weight(td)
        h.weight_diff = weight_diff(td)
        h.gate_no = gate_no(td)
        h.horse_no = horse_no(td)
        h.popularity = popularity(td)
        h.save
      end
    end

    def horse_id(tr)
      tr.search('td')[2].at_css('a').attr('href').match(/(\d+)/)[1]
    end

    def horse_name(tr)
      tr.search('td')[2].at_css('a').text.strip
    end

    def race(td)
      td.search('a')[0].attr('href').match(/(\d+)/)[1]
    end

    def order(td)
      td.at_css('div').attr('class').match(/i(\d{2})(\d{2})/)[2].to_i
    end

    def jockey_id(td)
      td.search('a')[1].attr('href').match(/(\d+)/)[1]
    end

    def time(td)
      td.search('a')[1].previous_element.text
    end

    def weight(td)
      td.at_css('a + br').next_sibling.text.match(/(\d+)\(([+-]?\d+| - )\) \[(\d)\](\d{1,2})\((\d{1,2})人\)/)[1]
    end

    def weight_diff(td)
      td.at_css('a + br').next_sibling.text.match(/(\d+)\(([+-]?\d+| - )\) \[(\d)\](\d{1,2})\((\d{1,2})人\)/)[2]
    end

    def gate_no(td)
      td.at_css('a + br').next_sibling.text.match(/(\d+)\(([+-]?\d+| - )\) \[(\d)\](\d{1,2})\((\d{1,2})人\)/)[3]
    end

    def horse_no(td)
      td.at_css('a + br').next_sibling.text.match(/(\d+)\(([+-]?\d+| - )\) \[(\d)\](\d{1,2})\((\d{1,2})人\)/)[4]
    end

    def popularity(td)
      td.at_css('a + br').next_sibling.text.match(/(\d+)\(([+-]?\d+| - )\) \[(\d)\](\d{1,2})\((\d{1,2})人\)/)[5]
    end

    def jockey_weight(td)
      td.search('a')[1].next_sibling.text.delete('()')
    end
  end
end
