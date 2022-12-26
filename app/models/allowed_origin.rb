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
class AllowedOrigin < ApplicationRecord
  belongs_to :game

  validates :origin,
            presence: true,
            length: { in: 1..255 },
            uniqueness: { scope: :game_id }
end
