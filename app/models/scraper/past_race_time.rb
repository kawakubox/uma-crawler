# frozen_string_literal: true
module Scraper
  class PastRaceTime
    attr_reader :doc

    def initialize(html)
      @doc = Nokogiri::HTML(html)
    end

    def race_id
      doc.search('a')[0].attr('href').match(/(\d+)/)[1]
    end

    def passage_order
      md = doc.text.match(/((\d{2}-)+\d{2})/)
      md[1] if md
    end

    def last_3f_time
      doc.text.match(/\(.*\) ([0-9.]{4})/)[1].to_f
    end
  end
end
