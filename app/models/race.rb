# frozen_string_literal: true

class Race < ApplicationRecord
  belongs_to :event

  def url
    "https://keiba.yahoo.co.jp/race/result/#{id}/"
  end
end
