# frozen_string_literal: true

# == Schema Information
#
# Table name: game_signals
#
#  id         :bigint           not null, primary key
#  data       :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  game_id    :bigint           not null
#  sender_id  :bigint           not null
#
# Indexes
#
#  index_game_signals_on_game_id    (game_id)
#  index_game_signals_on_sender_id  (sender_id)
#
# Foreign Keys
#
#  fk_rails_...  (game_id => games.id)
#  fk_rails_...  (sender_id => players.id)
#
class GameSignal < ApplicationRecord
  belongs_to :game
  belongs_to :sender, class_name: 'Player'

  validates :data, length: { within: 0..100 }
end
