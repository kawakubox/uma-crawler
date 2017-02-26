# frozen_string_literal: true

class Scraper::RaceMeta
  attr_reader :doc

  def initialize(html:)
    @doc = Nokogiri::HTML(html)
  end

  def race_no
    @doc.at_css('#raceNo').text.delete('R').strip
  end

  def title
    @doc.at_css('#raceTit h1').text.match(/(.*)(（(.*)）)?/)[1].strip
  end

  def grade
    @doc.at_css('#raceTit h1').text.match(/(.*)(（(.*)）)?/)[3]&.strip
  end

  def course_type
    @doc.at_css('#raceTitMeta').text.split('|')[0].match(/(芝|ダ|障害)・(左|右|芝→ダート) *(\d+)m/)[1]
  end

  def direction
    @doc.at_css('#raceTitMeta').text.split('|')[0].match(/(芝|ダ|障害)・(左|右|芝→ダート) *(\d+)m/)[2]
  end

  def distance
    @doc.at_css('#raceTitMeta').text.split('|')[0].match(/(芝|ダ|障害)・(左|右|芝→ダート) *(\d+)m/)[3]
  end

  def weather
    @doc.search('#raceTitMeta img')[0].attr('alt')
  end

  def course_condition
    @doc.search('#raceTitMeta img')[1].attr('alt')
  end
end
