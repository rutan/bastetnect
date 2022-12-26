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
class ScoreboardItem < ApplicationRecord
  belongs_to :scoreboard
  belongs_to :player

  validates :player,
            uniqueness: { scope: :scoreboard_id }
  validates :score, presence: true, inclusion: { in: -999_999_999_999_999..999_999_999_999_999 }

  scope :order_with_rank, ->(scoreboard) do
    order(score: scoreboard.rank_order, updated_at: :asc)
  end

  def rank
    scoreboard.guess_rank(score, updated_at)
  end

  def update_score!(new_score)
    return unless can_overwrite_score?(new_score)

    self.score = new_score
    save!
  end

  def can_overwrite_score?(new_score)
    return true if new_record?
    return true if scoreboard.overwrite_best_score?

    if scoreboard.rank_order_asc?
      new_score < score
    else
      new_score > score
    end
  end
end
