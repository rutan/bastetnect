# frozen_string_literal: true

# == Schema Information
#
# Table name: scoreboards
#
#  id                      :bigint           not null, primary key
#  index                   :integer          not null
#  is_overwrite_best_score :boolean          default(FALSE)
#  name                    :string(64)       not null
#  rank_order              :integer          not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  game_id                 :bigint           not null
#
# Indexes
#
#  index_scoreboards_on_game_id            (game_id)
#  index_scoreboards_on_game_id_and_index  (game_id,index) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (game_id => games.id)
#
class Scoreboard < ApplicationRecord
  belongs_to :game
  has_many :scoreboard_items, dependent: :restrict_with_exception

  validates :index,
            presence: true,
            uniqueness: { scope: :game_id }
  validates :rank_order, presence: true

  enum :rank_order, {
    asc: 0,
    desc: 1
  }, prefix: true

  def overwrite_best_score?
    is_overwrite_best_score
  end

  def guess_rank(score, time = Time.zone.now)
    scoreboard_items
      .joins(:player)
      .merge(Player.visible_for_list)
      .where(score: rank_order_asc? ? ...score : (score + 1)..)
      .or(scoreboard_items.where(score:, updated_at: ...time))
      .count + 1
  end
end
