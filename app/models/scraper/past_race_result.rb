# frozen_string_literal: true
module Scraper
  class PastRaceEntry
    attr_reader :doc

    # @param [Race] :race
    def initialize(race:)
      @race = race
      @doc = Nokogiri::HTML(open(race.entry_url)).at_css('.denmaLs')
    end

    def scrape
      doc.search('tr')[1..-1].map { |tr| row(tr) }
    end

    def row(tr)
      horse = Horse.find_or_create_by(id: horse_id(tr)) do |instance|
        instance.name = horse_name(tr)
      end

      tr.search(td)[4..-1].map do |td|
        next if td.text.strip.blank?
        race = Race.find_or_create_by(id: race(td))
        history = HorseHistory.find_or_initialize_by(horse: horse, race: @race)
        history.save
      end
    end

    def race(td)
      td.at_css('div.denmaCk a').attr('href').match(/(\d+)/)[1]
    end

    def gate_no(tr)
      tr.search('td')[0].text.strip
    end

    def horse_no(tr)
      tr.search('td')[1].text.strip
    end

    def horse_id(tr)
      tr.search('td')[2].at_css('a').attr('href').match(/(\d+)/)[1]
    end

    def horse_name(tr)
      tr.search('td')[2].at_css('a').text.strip
    end

    def weight(tr)
      tr.search('td')[3].children[0].text.strip
    end

    def weight_diff(tr)
      tr.search('td')[3].children[2].text.strip.gsub(/[()]/, '').to_i
    end

    def jockey_id(tr)
      tr.search('td')[4].at_css('a').attr('href').split('/').last
    end

    def jockey_name(tr)
      tr.search('td')[4].at_css('a').text
    end

    def jockey_weight(tr)
      tr.search('td')[4].children[2].text.gsub(/[▲△☆]/, '').strip
    end

    def trainer_id(tr)
      tr.search('td')[2].at_css('span a').attr('href').split('/').last
    end

    def trainer_name(tr)
      tr.search('td')[2].at_css('span a').text
    end
  end
end
