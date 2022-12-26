# frozen_string_literal: true

# == Schema Information
#
# Table name: scoreboard_items
#
#  id            :bigint           not null, primary key
#  score         :bigint           default(0)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  player_id     :bigint           not null
#  scoreboard_id :bigint           not null
#
# Indexes
#
#  index_scoreboard_items_on_player_id                    (player_id)
#  index_scoreboard_items_on_scoreboard_id                (scoreboard_id)
#  index_scoreboard_items_on_scoreboard_id_and_player_id  (scoreboard_id,player_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (player_id => players.id)
#  fk_rails_...  (scoreboard_id => scoreboards.id)
#
FactoryBot.define do
  factory :scoreboard_item do
    scoreboard
    player
    score { 1000 }
  end
end
