# frozen_string_literal: true

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
