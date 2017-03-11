# frozen_string_literal: true
class HorseHistory < ApplicationRecord
  belongs_to :horse
  belongs_to :race
  belongs_to :jockey, optional: true
  belongs_to :trainer, optional: true
end
