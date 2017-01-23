# frozen_string_literal: true

class Scraper::Event
  attr_reader :doc

  # @param [String] :html Event page html contents
  # @param [Event] :event
  def initialize(html:, event:)
    @doc = Nokogiri::HTML(html)
    @event = event
  end

  # @return [Array<String>] race page path (without protocol and hostname)
  def race_urls
    @doc.search('td a').map do |a|
      url = a.attr('href')
      url if url =~ %r{/race/result/.+}
    end.compact
  end
end
