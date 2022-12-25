# frozen_string_literal: true

class AllowedOrigin < ApplicationRecord
  belongs_to :game

  validates :origin,
            presence: true,
            length: { in: 1..255 },
            uniqueness: { scope: :game_id }
end
