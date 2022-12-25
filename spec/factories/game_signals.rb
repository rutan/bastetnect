# frozen_string_literal: true

FactoryBot.define do
  factory :game_signal do
    association :game
    association :sender, factory: :player

    data { 'text' }
  end
end
