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
FactoryBot.define do
  factory :game_signal do
    game
    sender factory: %i[player]

    data { 'text' }
  end
end
