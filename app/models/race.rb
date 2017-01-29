# frozen_string_literal: true

class Race < ApplicationRecord
  belongs_to :event
  has_many :refunds

  def result_url
    "https://keiba.yahoo.co.jp/race/result/#{id}/"
  end
end
