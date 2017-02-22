# frozen_string_literal: true

module Scraper
  class RaceOrder
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
      race_order = ::RaceOrder.find_or_initialize_by(race: @race, order: order(tr))
      race_order.attributes = {
        gate_no: gate_no(tr),
        horse_no: horse_no(tr),
        horse_id: horse_id(tr),
        horse_name: horse_name(tr),
        weight: weight(tr),
        weight_diff: weight_diff(tr),
        time: time(tr),
        order_diff: order_diff(tr),
      }
      race_order
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
      tr.search('td')[3].at_css('span').text.match(/\/(\d+)\((.*)\)\/(.*)/)[1]
    end

    def weight_diff(tr)
      tr.search('td')[3].at_css('span').text.match(/\/(\d+)\((.*)\)\/(.*)/)[2]
    end

    def time(tr)
      tr.search('td')[4].child.text.presence
    end

    def order_diff(tr)
      tr.search('td')[4].at_css('span').text.presence
    end
  end
end
