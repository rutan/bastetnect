# frozen_string_literal: true

class GameSignal < ApplicationRecord
  belongs_to :game
  belongs_to :sender, class_name: 'Player'

  validates :data, length: { within: 0..100 }
end
