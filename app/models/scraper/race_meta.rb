# frozen_string_literal: true

class Scraper::RaceMeta
  attr_reader :doc

  def initialize(html:)
    @doc = Nokogiri::HTML(html)
  end

  def race_no
    @doc.at_css('#raceNo').text.delete('R').strip
  end

  def ordinal
    md = @doc.at_css('#raceTit h1').text.match(/第(\d+)回/)
    md[1] if md
  end

  def title
    @doc.at_css('#raceTit h1').text.gsub(/第(\d+)回/, '').split(/[（）]/)[0].strip
  end

  def grade
    @doc.at_css('#raceTit h1').text.split(/[（）]/)[1]&.strip
  end

  def course_type
    @doc.at_css('#raceTitMeta').text.split('|')[0].match(/(芝|ダート|障害)・(左|右|直線|芝(→ダート)?)・?(内|外|内2周)? *(\d+)m/)[1]
  end

  def direction
    md = @doc.at_css('#raceTitMeta').text.split('|')[0].match(/(芝|ダート|障害)・(左|右|直線|芝(→ダート)?)・?(内|外|内2周)? *(\d+)m/)
    [md[2], md[4]].join if md
  end

  def distance
    @doc.at_css('#raceTitMeta').text.split('|')[0].match(/(芝|ダート|障害)・(左|右|直線|芝(→ダート)?)・?(内|外|内2周)? *(\d+)m/)[5]
  end

  def weather
    @doc.search('#raceTitMeta img')[0].attr('alt')
  end

  def course_condition
    @doc.search('#raceTitMeta img')[1].attr('alt')
  end
end
