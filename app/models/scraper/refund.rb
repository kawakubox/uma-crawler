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
      bet_type = nil
      @doc.search('.resultYen tr').each do |tr|
        bet_type = tr.at_css('th')&.text || bet_type
        winning_number = tr.search('td')[0].text
        refund = ::Refund.find_or_initialize_by(race: @race, bet_type: bet_type, winning_number: winning_number)
        refund.payout = tr.search('td')[1].text.delete(',')
        refund.popularity = tr.search('td')[2].text.delete(',')
        refund.save
      end
    end
  end
end
