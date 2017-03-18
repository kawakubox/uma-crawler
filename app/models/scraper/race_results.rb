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
      doc.search('tr')[1..-1].map { |tr| row(tr) }
    end

    def row(tr)
      horse = Horse.find_or_create_by(id: horse_id(tr)) do |instance|
        instance.name = horse_name(tr)
      end

      jockey = Jockey.find_or_create_by(id: jockey_id(tr)) do |instance|
        instance.name = jockey_name(tr)
      end

      trainer = Trainer.find_or_create_by(id: trainer_id(tr)) do |instance|
        instance.name = trainer_name(tr)
      end

      history = HorseHistory.find_or_initialize_by(horse: horse, race: @race)
      history.horse = horse
      history.jockey = jockey
      history.trainer = trainer
      history.order = order(tr)
      history.gate_no = gate_no(tr)
      history.horse_no = horse_no(tr)
      history.weight = weight(tr)
      history.weight_diff = weight_diff(tr)
      history.time = time(tr)
      history.order_diff = order_diff(tr)
      history.passage_order = passage_order(tr)
      history.last_3f_time = last_3f_time(tr)
      history.jockey_weight = jockey_weight(tr)
      history.popularity = popularity(tr)
      history.odds = odds(tr)
      history.save
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
