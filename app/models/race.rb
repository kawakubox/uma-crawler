# frozen_string_literal: true
class Race < ApplicationRecord
  belongs_to :event
  belongs_to :race_name, optional: true
  has_many :refunds

  before_validation :set_event

  def result_url
    "https://keiba.yahoo.co.jp/race/result/#{id}/"
  end

  def entry_url
    "https://keiba.yahoo.co.jp/race/denma/#{id}/"
  end

  def past_race_results_url
    "https://keiba.yahoo.co.jp/race/denma/#{id}/?page=2"
  end

  def past_race_time_url
    "https://keiba.yahoo.co.jp/race/denma/#{id}/?page=3"
  end

  def set_event
    self.event = Event.find_or_create_by(id: id.to_s[0...-2])
  end
end
