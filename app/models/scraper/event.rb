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

  def races
    @doc.search('tr').map do |tr|
      next if tr.search('td').count < 5
      race_id = tr.at_css('td a').attr('href').match(%r{/race/result/(\d+)})[1]
      Race.find_or_create_by(id: race_id) do |race|
        race.event = @event
      end
    end
  end
end
