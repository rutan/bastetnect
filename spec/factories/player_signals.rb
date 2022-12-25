# frozen_string_literal: true

FactoryBot.define do
  factory :player_signal do
    player
    association :sender, factory: :player
    data { 'data' }
  end
end
