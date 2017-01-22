# frozen_string_literal: true

class Scraper::Event
  attr_reader :doc

  # @param [String] :html Event page html contents
  def initialize(html:)
    @doc = Nokogiri::HTML(html)
  end

  # @return [Array<String>] race page path (without protocol and hostname)
  def race_urls
    @doc.search('td a').map do |a|
      url = a.attr('href')
      url if url.match(%r{/race/result/.+})
    end.compact
  end
end
