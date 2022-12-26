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
FactoryBot.define do
  factory :shared_save do
    player
    data { "data:#{rand}" }
  end
end
