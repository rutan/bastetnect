# frozen_string_literal: true

# == Schema Information
#
# Table name: allowed_origins
#
#  id         :bigint           not null, primary key
#  origin     :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  game_id    :bigint           not null
#
# Indexes
#
#  index_allowed_origins_on_game_id             (game_id)
#  index_allowed_origins_on_game_id_and_origin  (game_id,origin) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (game_id => games.id)
#
FactoryBot.define do
  factory :allowed_origin do
    game
    sequence :origin do |n|
      "sub#{n}.example.com"
    end
  end
end
