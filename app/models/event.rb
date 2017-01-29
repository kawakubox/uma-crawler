# frozen_string_literal: true

class Event < ApplicationRecord
  has_many :races

  def url
    "http://keiba.yahoo.co.jp/race/list/#{id}/"
  end
end
