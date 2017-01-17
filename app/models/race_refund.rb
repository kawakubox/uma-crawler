# frozen_string_literal: true

class RaceRefund
  attr_reader :doc

  def initialize(html:)
    @doc = Nokogiri::HTML(html)
  end

  def refund
    @doc.search('.resultYen tr').map do |tr|
      bet = tr.at_css('th')&.text
      result = tr.search('td')[0].text
      amount = tr.search('td')[1].text
      popularity = tr.search('td')[2].text
      [bet, result, amount, popularity]
    end
  end
end
