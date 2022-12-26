# frozen_string_literal: true

# == Schema Information
#
# Table name: player_signals
#
#  id         :bigint           not null, primary key
#  data       :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  player_id  :bigint           not null
#  sender_id  :bigint           not null
#
# Indexes
#
#  index_player_signals_on_player_id  (player_id)
#  index_player_signals_on_sender_id  (sender_id)
#
# Foreign Keys
#
#  fk_rails_...  (player_id => players.id)
#  fk_rails_...  (sender_id => players.id)
#
FactoryBot.define do
  factory :player_signal do
    player
    association :sender, factory: :player
    data { 'data' }
  end
end
