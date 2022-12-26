# frozen_string_literal: true

# == Schema Information
#
# Table name: players
#
#  id           :bigint           not null, primary key
#  last_play_at :datetime         not null
#  name         :string(32)       not null
#  status       :integer          default("active")
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  game_id      :bigint           not null
#
# Indexes
#
#  index_players_on_game_id       (game_id)
#  index_players_on_last_play_at  (last_play_at)
#  index_players_on_status        (status)
#
# Foreign Keys
#
#  fk_rails_...  (game_id => games.id)
#
FactoryBot.define do
  factory :player do
    game
    sequence :name do |n|
      "name#{n}"
    end
    status { 0 }

    after(:build) do |ins|
      build(:shared_save, player: ins)
    end
  end
end
