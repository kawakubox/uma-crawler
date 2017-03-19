# frozen_string_literal: true
module Scraper
  class PastRaceResult
    attr_reader :doc

    def initialize(html)
      @doc = Nokogiri::HTML(html)
    end

    def race_id
      doc.search('a')[0].attr('href').match(/(\d+)/)[1]
    end

    def order
      doc.search('div')[0].attr('class').match(/i(\d{2})(\d{2})/)[2].to_i
    end

    def jockey_id
      doc.search('a')[1].attr('href').match(/(\d+)/)[1]
    end

    def jockey_weight
      doc.search('a')[1].next_sibling.text.delete('()').to_f
    end

    def time
      doc.search('a')[1].previous_element.text
    end

    def weight
      doc.search('a + br')[0].next_sibling.text.match(/(\d+)\(([+-]?\d+| - )\) \[(\d)\](\d{1,2})\((\d{1,2})人\)/)[1].to_i
    end

    def weight_diff
      doc.search('a + br')[0].next_sibling.text.match(/(\d+)\(([+-]?\d+| - )\) \[(\d)\](\d{1,2})\((\d{1,2})人\)/)[2].to_i
    end

    def gate_no
      doc.search('a + br')[0].next_sibling.text.match(/(\d+)\(([+-]?\d+| - )\) \[(\d)\](\d{1,2})\((\d{1,2})人\)/)[3].to_i
    end

    def horse_no
      doc.search('a + br')[0].next_sibling.text.match(/(\d+)\(([+-]?\d+| - )\) \[(\d)\](\d{1,2})\((\d{1,2})人\)/)[4].to_i
    end

    def popularity
      doc.search('a + br')[0].next_sibling.text.match(/(\d+)\(([+-]?\d+| - )\) \[(\d)\](\d{1,2})\((\d{1,2})人\)/)[5].to_i
    end
  end
end
