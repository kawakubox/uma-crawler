# frozen_string_literal: true

class Event < ApplicationRecord
  def url
    "http://keiba.yahoo.co.jp/race/list/#{id}/"
  end
end
