# frozen_string_literal: true

FactoryBot.define do
  factory :scoreboard_item do
    scoreboard
    player
    score { 1000 }
  end
end
