# frozen_string_literal: true

# == Schema Information
#
# Table name: shared_saves
#
#  id         :bigint           not null, primary key
#  data       :text             default(""), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  player_id  :bigint           not null
#
# Indexes
#
#  index_shared_saves_on_player_id  (player_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (player_id => players.id)
#
class SharedSave < ApplicationRecord
  MAX_SHARED_DATA_BYTESIZE = 4.kilobytes

  belongs_to :player

  validates :player,
            uniqueness: true
  validates :data,
            bytesize: { maximum: MAX_SHARED_DATA_BYTESIZE },
            allow_nil: false
end
