# frozen_string_literal: true
class RaceResult < ApplicationRecord
  belongs_to :race
  belongs_to :horse
end
