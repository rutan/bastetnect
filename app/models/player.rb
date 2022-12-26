# frozen_string_literal: true

class Player < ApplicationRecord
  belongs_to :game

  has_one :shared_save, dependent: :destroy
  accepts_nested_attributes_for :shared_save

  has_many :player_signals, dependent: :restrict_with_exception
  has_many :sent_game_signals,
           class_name: 'GameSignal',
           foreign_key: 'sender_id',
           inverse_of: 'player',
           dependent: :restrict_with_exception
  has_many :sent_player_signals,
           class_name: 'PlayerSignal',
           foreign_key: 'sender_id',
           inverse_of: 'player',
           dependent: :restrict_with_exception
  has_many :scoreboard_items,
           dependent: :restrict_with_exception

  validates :name, presence: true, length: { in: 1..32 }
  validates :status, presence: true

  enum :status, {
    active: 0,
    shadow: 10,
    dead: 20
  }

  scope :visible_for_show, -> do
    active.or(shadow)
  end

  scope :visible_for_list, ->(current_player = nil) do
    active.tap do |sc|
      sc.or(where(player_id: current_player.id)) if current_player
    end
  end

  scope :recent_access, -> do
    order(last_play_at: :desc)
  end

  def shared_save
    super || build_shared_save
  end

  def generate_token
    GameAuthorizer.new(game, self).generate_token
  end
end
