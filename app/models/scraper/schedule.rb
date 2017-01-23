# frozen_string_literal: true

module Scraper
  class Schedule
    attr_reader :doc

    # @param [String] :html Schedule page html contents
    def initialize(html:)
      @doc = Nokogiri::HTML.parse(html)
    end

    # @return [Fixnum]
    def year
      @doc.at_css('.scheHead h3').text.match(/(\d+)年(\d+)月/)[1].to_i
    end

    # @return [Fixnum]
    def month
      @doc.at_css('.scheHead h3').text.match(/(\d+)年(\d+)月/)[2].to_i
    end

    # @param [Nokogiri::Node::XML]
    # @return [Fixnum]
    def date(tr)
      tr.at_css('td').child.text.match(/(\d+)日/)[1].to_i
    end

    # @param [Nokotiri::Node::XML]
    # @return [Fixnum]
    def event_id(tr)
      tr.at_css('td a').attr('href').match(%r{/(\d+)})[1].to_i
    end

    # @return [Array<Event>]
    def events
      @doc.search('tr').map do |tr|
        tds = tr.search('td')
        next if tds.blank? || tds.count < 3
        Event.find_or_create_by(id: event_id(tr)) do |event|
          event.held_on = Date.new(year, month, date(tr))
        end
      end.compact
    end
  end
end
