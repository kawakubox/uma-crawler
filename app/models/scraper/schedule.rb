# frozen_string_literal: true

class Scraper::Schedule
  attr_reader :doc

  # @param [String] :html Schedule page html contents
  def initialize(html:)
    @doc = Nokogiri::HTML.parse(html)
  end

  # @return [Array<String>] event page path (without protocol and hostname)
  def event_urls
    @doc.search('td a').map do |a|
      url = a.attr('href')
      url if url.match(%r{/race/list/.+})
    end.compact
  end
end
