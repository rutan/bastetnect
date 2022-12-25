# frozen_string_literal: true

class PlayerSignal < ApplicationRecord
  belongs_to :player
  belongs_to :sender, class_name: 'Player'

  validates :data, presence: true, length: { maximum: 100 }

  scope :recent_received, -> {
    order(id: :desc)
  }
end
