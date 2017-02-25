# frozen_string_literal: true
class RaceResult < ApplicationRecord
  belongs_to :race
  belongs_to :horse
  belongs_to :jockey
  belongs_to :trainer
end
