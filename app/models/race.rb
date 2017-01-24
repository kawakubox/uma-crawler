# frozen_string_literal: true

class Race < ApplicationRecord
  def url
    "https://keiba.yahoo.co.jp/race/result/#{id}/"
  end
end
