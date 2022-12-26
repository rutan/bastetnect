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
FactoryBot.define do
  factory :scoreboard do
    game
    sequence :name do |n|
      "scoreboard_#{n}"
    end
    index { 0 }
    rank_order { :desc }
  end
end
