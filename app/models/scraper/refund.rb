# frozen_string_literal: true

module Scraper
  class Refund
    attr_reader :doc
    attr_reader :race
  
    def initialize(race:)
      @race = race
      @doc = Nokogiri::HTML(open(race.result_url))
    end
  
    def scrape
      @doc.search('.resultYen tr').map do |tr|
        ::Refund.create(params(tr).merge(race: @race))
      end
    end

    def params(tr)
      {
        bet_type: tr.at_css('th')&.text,
        winning_number: tr.search('td')[0].text,
        payout: tr.search('td')[1].text,
        popularity: tr.search('td')[2].text
      }
    end
  end
end
