# frozen_string_literal: true
class Race < ApplicationRecord
  belongs_to :event
  has_many :refunds

  def result_url
    "https://keiba.yahoo.co.jp/race/result/#{id}/"
  end

  def entry_url
    "https://keiba.yahoo.co.jp/race/denma/#{id}/"
  end

  def past_race_results_url
    "https://keiba.yahoo.co.jp/race/denma/#{id}/?page=2"
  end
end
