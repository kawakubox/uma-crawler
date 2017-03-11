# frozen_string_literal: true
class Race < ApplicationRecord
  belongs_to :event
  has_many :refunds

  before_create :set_event

  def result_url
    "https://keiba.yahoo.co.jp/race/result/#{id}/"
  end

  def entry_url
    "https://keiba.yahoo.co.jp/race/denma/#{id}/"
  end

  def past_race_results_url
    "https://keiba.yahoo.co.jp/race/denma/#{id}/?page=2"
  end

  def set_event
    event = Event.find_or_create_by(id.ts_s[0...-2])
  end
end
