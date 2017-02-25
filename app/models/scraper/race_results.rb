# frozen_string_literal: true

module Scraper
  class RaceResults
    attr_reader :doc

    # @param [Race] :race
    def initialize(race:)
      @race = race
      @doc = Nokogiri::HTML(open(race.result_url)).at_css('#raceScore')
    end

    def scrape
      rows.map(&:save)
    end

    def rows
      doc.search('tr')[1..-1].map { |tr| row(tr) }
    end

    def row(tr)
      horse = Horse.find_or_create_by(id: horse_id(tr)) do |instance|
        instance.name = horse_name(tr)
      end

      jockey = Jockey.find_or_create_by(id: jockey_id(tr)) do |instance|
        instance.name = jockey_name(tr)
      end

      race_result = ::RaceResult.find_or_initialize_by(race: @race, horse_no: horse_no(tr))
      race_result.attributes = {
        order: order(tr),
        gate_no: gate_no(tr),
        horse_no: horse_no(tr),
        horse: horse,
        weight: weight(tr),
        weight_diff: weight_diff(tr),
        time: time(tr),
        order_diff: order_diff(tr),
        passage_order: passage_order(tr),
        last_3f_time: last_3f_time(tr),
        jockey: jockey,
        jockey_weight: jockey_weight(tr),
        popularity: popularity(tr),
        odds: odds(tr),
        trainer_id: trainer_id(tr),
        trainer_name: trainer_name(tr)
      }
      race_result
    end

    def order(tr)
      tr.search('td')[0].text.strip
    end

    def gate_no(tr)
      tr.search('td')[1].text.strip
    end

    def horse_no(tr)
      tr.search('td')[2].text.strip
    end

    def horse_id(tr)
      tr.search('td')[3].at_css('a').attr('href').match(/(\d+)/)[1]
    end

    def horse_name(tr)
      tr.search('td')[3].at_css('a').text.strip
    end

    def weight(tr)
      tr.search('td')[3].at_css('span').text.match(%r{/(\d+)\((.*)\)/(.*)})[1]
    end

    def weight_diff(tr)
      tr.search('td')[3].at_css('span').text.match(%r{\/(\d+)\((.*)\)\/(.*)})[2]
    end

    def time(tr)
      tr.search('td')[4].child.text.presence
    end

    def order_diff(tr)
      tr.search('td')[4].at_css('span').text.presence
    end

    def passage_order(tr)
      tr.search('td')[5].child.text.presence
    end

    def last_3f_time(tr)
      tr.search('td')[5].at_css('span').text.presence
    end

    def jockey_id(tr)
      tr.search('td')[6].at_css('a').attr('href').split('/').last
    end

    def jockey_name(tr)
      tr.search('td')[6].at_css('a').text
    end

    def jockey_weight(tr)
      tr.search('td')[6].at_css('span').text.gsub(/[▲△☆]/, '')
    end

    def popularity(tr)
      tr.search('td')[7].child.text
    end

    def odds(tr)
      tr.search('td')[7].at_css('span').text.gsub(/[()]/, '')
    end

    def trainer_id(tr)
      tr.search('td')[8].at_css('a').attr('href').split('/').last
    end

    def trainer_name(tr)
      tr.search('td')[8].at_css('a').text
    end
  end
end
